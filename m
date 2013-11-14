Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3KNRIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:08:20 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:27545 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3KNRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:08:08 -0500
X-AuditID: cbfec372-b7fcc6d0000068fc-5a-528503778795
Date: Thu, 14 Nov 2013 15:08:00 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Robert Richter <rric@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [GIT PULL] mpc85xx_edac changes for 3.13
Message-id: <20131114150800.7adc9577@samsung.com>
In-reply-to: <20131114142125.GA29214@jtlinux>
References: <20131112161901.GA15637@jtlinux>
 <CA+55aFzJhyo8bKBchYq0Q=rwPv_-v-xWgOKWxKBcSBycMZcmTg@mail.gmail.com>
 <20131114054750.GA27791@kroah.com> <20131114092009.GA4960@pd.tnic>
 <20131114091843.4bb72afc@samsung.com> <20131114112418.GH4960@pd.tnic>
 <20131114142125.GA29214@jtlinux>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/hQN1y5tYgg3U/NCzaTvxms/i84R+b
	xcR+TYury84yWTQvXs9mMXn/JTaLC6camCwu75rDZnFw1UYmi0d9b9kduDy+t/axeGxa1cnm
	cWLGbxaP/XPXsHvs2vOWxeP9vqtsHptPV3t83iTnMeVQO0sAZxSXTUpqTmZZapG+XQJXxpHe
	DSwFEzgq3r7UaWCcx9bFyMkhIWAisfPoWSYIW0ziwr31QHEuDiGBJYwSH9//YIFwupkkJj9f
	DVbFIqAqsXHWNhYQm03ASOJVYwsriC0CZG+9fJsRpIFZ4A+TRNePaWANwgKmEoeuXWcGsXkF
	DCWev5sH1sApoCvRvmEdE8SGxUwS7Z1/gKZyAN3hJLH7gBREvaDEj8n3wJYxC2hJbN7WxAph
	y0tsXvOWeQKjwCwkZbOQlM1CUraAkXkVo2hpcXJBcVJ6rqFecWJucWleul5yfu4mRkikFO1g
	fLbB6hCjAAejEg9vwc7mICHWxLLiytxDjBIczEoivDyMrUFCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGKOOil2vjMnyvvn2fWR06n2+e5lp/h9f2wq5nrh7pfMxW/Fm9p+3VPwlonuYJrUdc/ab
	sbju7lIRp/w5d9ueibxKdXF0aPuc4RCXKCZhbWLSJVPzUkm1WOrhDK9V6Xzzr9S479y1mkdt
	3oT/9zRyTtan6aZ/Fffb8FK0ROXQEs7tX8qbf7kcUmIpzkg01GIuKk4EAGZCllJyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 14 Nov 2013 15:21:25 +0100
Johannes Thumshirn <johannes.thumshirn@men.de> escreveu:

> On Thu, Nov 14, 2013 at 12:24:18PM +0100, Borislav Petkov wrote:
> > On Thu, Nov 14, 2013 at 09:18:43AM -0200, Mauro Carvalho Chehab wrote:
> > > So, in practice, Borislav was working as a maintainer for amd64 EDAC
> > > patches, and I working mainly as Intel EDAC maintainer. The (few)
> > > other arm EDAC patches were either coming via my tree or via Boris
> > > tree, depending on who got them first.
> >
> > Yeah, and I think this has worked pretty good in the past

Fully agreed.

> > so if you want
> > to, we can continue the same thing of sharing the load on EDAC patches
> > and we both do interim maintainers until Doug steps in.

Works for me.

> >
> > And since it won't change any workflow for Linus, he's probably fine
> > with it too.
> >
> > Yes, no? Comments?
> 
> OK for me. For the MPC85xx EDAC I'll do the testing then and either Borislav or
> Mauro send them upstream.

Ok.

Regards,
Mauro

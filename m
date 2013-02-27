Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210Ab3B0Pk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:40:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45562 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760015Ab3B0Pk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:40:28 -0500
Date: Wed, 27 Feb 2013 10:40:02 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Chen Gang <gang.chen@asianux.com>, roger.pau@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel <xen-devel@lists.xen.org>,
        dgdegra@tycho.nsa.gov,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/xen-blkback: preq.dev is used without
 initialized
Message-ID: <20130227154002.GE24932@phenom.dumpdata.com>
References: <512D90F2.9070200@asianux.com>
 <512DE6B302000078000C1631@nat28.tlf.novell.com>
 <512DE213.3050001@asianux.com>
 <512DF1DF02000078000C16A4@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <512DF1DF02000078000C16A4@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:45:35AM +0000, Jan Beulich wrote:
> >>> On 27.02.13 at 11:38, Chen Gang <gang.chen@asianux.com> wrote:
> > 于 2013年02月27日 17:57, Jan Beulich 写道:
> >> You also could have mentioned that even before commit 
> >> 01c681d4c70d64cb72142a2823f27c4146a02e63 the value printed
> >> here was bogus, as it was the guest provided value from
> >> req->u.rw.handle rather than the actual device.
> > 
> >   pardon ?
> > 
> >   I guess what you said is :
> >     my patch seems ok, but the comments need improving.
> >     need add "additional info" in comments:
> >       "before commit 01c681d4c70d64cb72142a2823f27c4146a02e63
> >        the value printed here was bogus, as it was the guest
> >        provided value from req->u.rw.handle rather than the
> >        actual device".
> > 
> >   is it correct ?
> 
> Yes (and you might have missed the ACK that I had already sent
> before this reply - that mail got bounced for your address).

Yup. Chen, could you respin the patch with the extra comment and
the Ack from Jan please?

Thank you!
> 
> Jan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab3APRV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:21:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54078 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3APRVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:21:25 -0500
Date: Wed, 16 Jan 2013 17:27:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <balbi@ti.com>
Cc: Alan Cox <alan@linux.intel.com>, <arve@android.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <mikechan@google.com>
Subject: Re: [PATCH 06/10] goldfish: emulated MMC device
Message-ID: <20130116172701.62c5355b@pyramind.ukuu.org.uk>
In-Reply-To: <20130116171839.GD6377@arwen.pp.htv.fi>
References: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
	<20130116165937.15183.76416.stgit@bob.linux.org.uk>
	<20130116171839.GD6377@arwen.pp.htv.fi>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 19:18:39 +0200
Felipe Balbi <balbi@ti.com> wrote:

> Hi,
> 
> On Wed, Jan 16, 2013 at 04:59:38PM +0000, Alan Cox wrote:
> > +#define OMAP_MMC_CMDTYPE_BC	0
> > +#define OMAP_MMC_CMDTYPE_BCR	1
> > +#define OMAP_MMC_CMDTYPE_AC	2
> > +#define OMAP_MMC_CMDTYPE_ADTC	3
> 
> OMAP ?? :-) If you guys are emulating an OMAP mmc controller, why don't
> you just re-use the omap mmc driver instead of duplicating the code ?

It's not an OMAP controller, it just has some similar behaviours. I guess
that's because the original Google emulation target was entirely ARM
based.

Alan

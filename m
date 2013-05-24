Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3EXTtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 15:49:36 -0400
Received: from 18.mo4.mail-out.ovh.net ([188.165.54.143]:50694 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755240Ab3EXTtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 15:49:35 -0400
Date: Fri, 24 May 2013 21:45:22 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [RESEND PATCH] pwm: pwm-atmel-tcb: pinctrl support
Message-ID: <20130524194522.GA31700@game.jcrosoft.org>
References: <1369327132-31935-1-git-send-email-b.brezillon@overkiz.com>
 <20130523193545.GF17462@avionic-0098.adnet.avionic-design.de>
 <519F21BA.6040403@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519F21BA.6040403@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14144680531490220921
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:15 Fri 24 May     , boris brezillon wrote:
> On 23/05/2013 21:35, Thierry Reding wrote:
> >On Thu, May 23, 2013 at 06:38:52PM +0200, Boris BREZILLON wrote:
> >>Hello,
> >>
> >>I sent a patch 1 month ago to add pinctrl support to pwm-atmel-tcb
> >>driver and didn't get any review.
> >>
> >>Could you take a look?
> >>
> >>This patch adds pins request for the pwm device exposed by the TC
> >>block using the pinctrl subsystem.
> >I was actually looking at this a few days back and thought I remembered
> >this being handled in the core now. There was some discussion about this
> >back in January (?) as far as I remember. I just verified that indeed
> >there is code in the driver core code to do this. See commit:
> >
> >	ab78029ecc347debbd737f06688d788bd9d60c1d  drivers/pinctrl: grab default handles from device core
> >
> >Are you sure this is really necessary in the driver?
> No.
> 
> Thanks for pointing this commit out (I didn't notice the default
> handles were grabbed
> from device core).
> 
> I'll test it without this patch.

You can drop it, it's handled at core level for every struct device

Best Regards,
J.
> 
> Best Regards,
> Boris
> >Thierry
> 

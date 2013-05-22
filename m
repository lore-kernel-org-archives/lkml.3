Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3EVKto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:49:44 -0400
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:47288 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753238Ab3EVKtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:49:40 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2013 06:49:40 EDT
Date: Wed, 22 May 2013 12:35:25 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v2 1/2] clk: Disable unused clocks after deferred
 probing is done
Message-ID: <20130522103525.GD9937@game.jcrosoft.org>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
 <1368124502-18830-1-git-send-email-skannan@codeaurora.org>
 <20130510064520.GI3041@game.jcrosoft.org>
 <518D7CC3.6050000@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518D7CC3.6050000@codeaurora.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11558769920362916678
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeigedrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeigedrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:03 Fri 10 May     , Saravana Kannan wrote:
> On 05/09/2013 11:45 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >On 11:35 Thu 09 May     , Saravana Kannan wrote:
> >>With deferred probing, late_initcall() is too soon to declare a clock as
> >>unused. Wait for deferred probing to finish before declaring a clock as
> >>unused. Since deferred probing is done in late_initcall(), do the unused
> >>check to late_initcall_sync.
> >
> >Nack for both regulator & clk
> >
> >you can not known when the clock need to be shutdown
> >
> >example display splash screen set by the bootloader and display as module
> >
> >Best Regards,
> >J.
> 
> You are joking right? This is already done in the kernel. If you
> don't want that, please rip out the code and try to get that picked
> up. I'm sending out this patch for fix what's currently in the
> kernel for those who care for the current feature.

so this feature is nightmare we need to KILL it

Best Regards,
J.
> 
> Regards,
> Saravana
> 
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation

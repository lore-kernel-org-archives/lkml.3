Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaG2Mm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:42:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15751 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752523AbaG2Mmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:42:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19nNk2qGbhiDAsSXG6LP+Kb
Date: Tue, 29 Jul 2014 05:41:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Michael Trimarchi <michael@amarulasolutions.com>,
        Marek Belisko <marek.belisko@gmail.com>, pawel.moll@arm.com,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm: dts: Add gta04a5 model
Message-ID: <20140729124120.GS29045@atomide.com>
References: <1406577213-9642-1-git-send-email-marek@goldelico.com>
 <1406577213-9642-4-git-send-email-marek@goldelico.com>
 <CAOf5uwk=ctww=pP4Ae+1C6i-oOtiYTv2NJbj1GpuPwVSKXB4Hw@mail.gmail.com>
 <CAAfyv35jvhzvjCKMwrpa=RQ1JkfcmthCsGDzwLW9Y6bq3Ww_fg@mail.gmail.com>
 <CAOf5uw=Fm9FXEH5ESqDC8pGjMbn5VQ1+MyPJVXSqGh_9+JRLHw@mail.gmail.com>
 <1FA8171E-1B7A-4684-887E-11593BB9C29E@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FA8171E-1B7A-4684-887E-11593BB9C29E@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dr. H. Nikolaus Schaller <hns@goldelico.com> [140728 13:45]:
> 
> Yes,
> the boot loader either loads gta04a3.dtb gta04.dtb or gta05.dtb
> depending on board revision.
> 
> Therefore we have multiple device tree files to represent such hardware
> differences. Like Gumstix Overo variants (using a  omap3-overo-base.dtsi)
> 
> And, this difference is not the only one. Other are to come later.
> 
> Unfortunately we were recommend to submit only DT nodes that already
> have drivers. Therefore, the "big picture" of the device variants support
> may not yet be visible from this patch.
> 
> I hope this gives a little background.

So what's the conclusion? Are changes needed to this patch
series or not?

Regards,

Tony

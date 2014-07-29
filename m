Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaG2NEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:04:31 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:64504 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaG2NE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:04:29 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9htPoyY0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 3/3] arm: dts: Add gta04a5 model
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20140729124120.GS29045@atomide.com>
Date: Tue, 29 Jul 2014 15:03:42 +0200
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
Content-Transfer-Encoding: 7bit
Message-Id: <589F7CA3-F245-4299-8E39-36A7FA9F3CBD@goldelico.com>
References: <1406577213-9642-1-git-send-email-marek@goldelico.com> <1406577213-9642-4-git-send-email-marek@goldelico.com> <CAOf5uwk=ctww=pP4Ae+1C6i-oOtiYTv2NJbj1GpuPwVSKXB4Hw@mail.gmail.com> <CAAfyv35jvhzvjCKMwrpa=RQ1JkfcmthCsGDzwLW9Y6bq3Ww_fg@mail.gmail.com> <CAOf5uw=Fm9FXEH5ESqDC8pGjMbn5VQ1+MyPJVXSqGh_9+JRLHw@mail.gmail.com> <1FA8171E-1B7A-4684-887E-11593BB9C29E@goldelico.com> <20140729124120.GS29045@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 29.07.2014 um 14:41 schrieb Tony Lindgren:

> * Dr. H. Nikolaus Schaller <hns@goldelico.com> [140728 13:45]:
>> 
>> Yes,
>> the boot loader either loads gta04a3.dtb gta04.dtb or gta05.dtb
>> depending on board revision.
>> 
>> Therefore we have multiple device tree files to represent such hardware
>> differences. Like Gumstix Overo variants (using a  omap3-overo-base.dtsi)
>> 
>> And, this difference is not the only one. Other are to come later.
>> 
>> Unfortunately we were recommend to submit only DT nodes that already
>> have drivers. Therefore, the "big picture" of the device variants support
>> may not yet be visible from this patch.
>> 
>> I hope this gives a little background.
> 
> So what's the conclusion? Are changes needed to this patch
> series or not?

I advocate that no changes are needed.

BR,
Nikolaus


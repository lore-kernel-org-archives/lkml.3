Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3LJU0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:26:49 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:32957 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3LJU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:26:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAEPRUYrw_owwBYEmmXO3=OG9pXrKPrJTwF+jPVm4+-Vvf0Xorw@mail.gmail.com>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
	<1386271244-3927-2-git-send-email-tim.kryger@linaro.org>
	<CAEPRUYrw_owwBYEmmXO3=OG9pXrKPrJTwF+jPVm4+-Vvf0Xorw@mail.gmail.com>
Date: Tue, 10 Dec 2013 12:26:45 -0800
Message-ID: <CAAYSxhp3MsnaX80tF7iCzUfjfjyQnOoZbTrtBKs_nAk4SUYReQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] ARM: dts: Declare clocks as fixed on bcm11351
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 11:18 PM, Christian Daudt <bcm@fixthebug.org> wrote:
> Applied to armsoc/for-3.14/dt

Could you wait till other maintainers provide their acks and then take
the entire series into a branch that feeds into the arm-soc
drivers-for-linus branch?

Thanks,
Tim Kryger

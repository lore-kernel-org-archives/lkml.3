Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3LMHsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 02:48:51 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34631 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3LMHst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 02:48:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAAYSxhp3MsnaX80tF7iCzUfjfjyQnOoZbTrtBKs_nAk4SUYReQ@mail.gmail.com>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
	<1386271244-3927-2-git-send-email-tim.kryger@linaro.org>
	<CAEPRUYrw_owwBYEmmXO3=OG9pXrKPrJTwF+jPVm4+-Vvf0Xorw@mail.gmail.com>
	<CAAYSxhp3MsnaX80tF7iCzUfjfjyQnOoZbTrtBKs_nAk4SUYReQ@mail.gmail.com>
Date: Thu, 12 Dec 2013 23:48:47 -0800
Message-ID: <CAEPRUYoJJ054rGhZmMMBy93ZtLrFJPRkM6LHmjygcyaDqzbDEw@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] ARM: dts: Declare clocks as fixed on bcm11351
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>
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

On Tue, Dec 10, 2013 at 12:26 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> On Mon, Dec 9, 2013 at 11:18 PM, Christian Daudt <bcm@fixthebug.org> wrote:
>> Applied to armsoc/for-3.14/dt
>
> Could you wait till other maintainers provide their acks and then take
> the entire series into a branch that feeds into the arm-soc
> drivers-for-linus branch?
>
> Thanks,
> Tim Kryger

I'll try to sync with other maintainers to pull it in together. I'll
leave this commit in as-is for now as it is harmless on its own. I'll
back it off before 3.14 merge if it poses a problem.

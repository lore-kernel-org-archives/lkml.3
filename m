Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3FYQyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:54:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52461 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FYQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:54:01 -0400
Message-ID: <51C9CB27.3010405@codeaurora.org>
Date: Tue, 25 Jun 2013 09:53:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: john.stultz@linaro.org, tglx@linutronix.de, shc_work@mail.ru,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] ARM: mach-clps711x: common: Use linux/sched_clock.h
References: <1372118615-14805-1-git-send-email-festevam@gmail.com> <51C8E637.2060106@codeaurora.org> <CAOMZO5CzphELkwr8gGP1LfA3HJ02CZpnzneETaZcn9YXws=ieQ@mail.gmail.com>
In-Reply-To: <CAOMZO5CzphELkwr8gGP1LfA3HJ02CZpnzneETaZcn9YXws=ieQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/13 19:44, Fabio Estevam wrote:
> On Mon, Jun 24, 2013 at 9:37 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> Is this one in the arm-soc tree? I plan to make a sweep after 3.11-rc1
> I haven't see a fix for this in the linux-arm-kernel list.

http://article.gmane.org/gmane.linux.kernel/1513390 was posted a few
days ago and was merged to the tip tree just before your patch. That
patch looks good because that sched_clock user is going through timers/core.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


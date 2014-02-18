Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaBRWLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:11:19 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60482 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaBRWLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:11:17 -0500
Message-ID: <5303DA83.7050509@codeaurora.org>
Date: Tue, 18 Feb 2014 14:11:15 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] genirq: Add devm_request_any_context_irq()
References: <1388709460-19222-3-git-send-email-sboyd@codeaurora.org> <tip-0668d3065128d39449c097e62dbdb5707820137d@git.kernel.org> <20140211064640.GG10784@codeaurora.org> <alpine.DEB.2.02.1402111527090.21991@ionos.tec.linutronix.de> <20140211163903.GD12106@core.coreip.homeip.net>
In-Reply-To: <20140211163903.GD12106@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/14 08:39, Dmitry Torokhov wrote:
> On Tue, Feb 11, 2014 at 03:32:44PM +0100, Thomas Gleixner wrote:
>> tip/irq/devm contains only this commit so Dmitry can pull it in.
> Unfortunately it is based on top of some random commit. If you could
> create a branch off 3.14 with this commit I would be able to pull it in.
>
>

Looks like it got merged for 3.14-rc3. Thanks Thomas. Dmitry, I think
everything is in place now?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


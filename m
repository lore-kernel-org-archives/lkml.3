Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbaCDU3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:29:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38582 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781AbaCDU3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:29:07 -0500
Message-ID: <53163791.50202@codeaurora.org>
Date: Tue, 04 Mar 2014 12:29:05 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [RESEND] ARM: footbridge: remove obsolete IRQF_DISABLED
References: <1386395865-11910-1-git-send-email-michael.opdenacker@free-electrons.com> <1393964413-16829-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1393964413-16829-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/14 12:20, Michael Opdenacker wrote:
> This patch proposes to remove the IRQF_DISABLED flag from footbridge
> code. It's a NOOP since 2.6.35.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

You should send this to Russell's patch tracker[1] given that nobody has
commented in over 6 months on two resends.

[1] http://www.arm.linux.org.uk/developer/patches/info.php

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


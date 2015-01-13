Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbbAMA0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 19:26:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36959 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbbAMA0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 19:26:42 -0500
Message-ID: <54B46640.3000804@codeaurora.org>
Date: Mon, 12 Jan 2015 16:26:40 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial: Remove console unregistration
 from driver exit.
References: <1421070732-24527-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1421070732-24527-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 05:52 AM, Pramod Gurav wrote:
> unregister_console() will be called from uart_remove_one_port() while
> removing the platform driver. So not necessary to call it in driver
> exit path.
>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project


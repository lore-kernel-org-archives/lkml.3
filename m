Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbaGWX0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:26:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37333 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370AbaGWX0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:26:37 -0400
Message-ID: <53D044AB.4060009@codeaurora.org>
Date: Wed, 23 Jul 2014 16:26:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kiran Padwal <kiran.padwal21@gmail.com>
CC: davidb@codeaurora.org, gregkh@linuxfoundation.org, dwalker@fifo99.com,
        bryanh@codeaurora.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        kiran.padwal@smartplayin.com
Subject: Re: [PATCH] tty: serial: msm: Make of_device_id array const
References: <1406111186-16627-1-git-send-email-kiran.padwal@smartplayin.com>
In-Reply-To: <1406111186-16627-1-git-send-email-kiran.padwal@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/14 03:26, Kiran Padwal wrote:
> Make of_device_id array const, because all OF functions handle it as const.
>
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


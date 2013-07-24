Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3GXUad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:30:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50942 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3GXUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:30:28 -0400
Date: Wed, 24 Jul 2013 13:30:26 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/4] msm_serial: Make baud_code detection more dynamic
Message-ID: <20130724203026.GD10926@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
 <1374691051-28544-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1374691051-28544-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:37:30AM -0700, Stephen Boyd wrote:
>Currently msm_set_baud_rate() assumes the uart clock rate is
>1.8432 MHz. This is not always true, and limits our options to
>program the baud rate. Instead of assuming the rate and
>hard-coding the baud_code based on it, calculate the divider that
>we want and try to find the closest baud_code that matches. This
>allows us to support uarts with faster clock speeds.
>
>Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>---
> drivers/tty/serial/msm_serial.c | 98 ++++++++++++++++++-----------------------
> drivers/tty/serial/msm_serial.h | 18 ++------
> 2 files changed, 48 insertions(+), 68 deletions(-)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

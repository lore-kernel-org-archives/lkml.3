Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab3GXUbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:31:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50986 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3GXUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:31:09 -0400
Date: Wed, 24 Jul 2013 13:31:07 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 4/4] msm_serial: Send more than 1 character at a time on
 UARTDM
Message-ID: <20130724203106.GE10926@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
 <1374691051-28544-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1374691051-28544-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:37:31AM -0700, Stephen Boyd wrote:
>UARTDM cores have a TX fifo that can accept more than one
>character per register write, but the msm_serial driver currently
>only supports 1 character mode. Add support for this mode of operation
>to speed up the transmit path on DM devices.
>
>Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>---
> drivers/tty/serial/msm_serial.c | 51 ++++++++++++++++++++++++++---------------
> 1 file changed, 32 insertions(+), 19 deletions(-)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

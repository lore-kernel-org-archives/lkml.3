Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3GXUbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:31:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51011 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3GXUbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:31:53 -0400
Date: Wed, 24 Jul 2013 13:31:51 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4] msm_serial fixes and improvements
Message-ID: <20130724203151.GF10926@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:37:27AM -0700, Stephen Boyd wrote:
>Here are a couple fixes and improvements to the msm_serial
>driver. The first two patches fix a bug on UARTDM devices and
>silence sparse warnings. The last two patches improve the baud
>code detection and increase the throughput on UARTDM devices.
>
>After this it is rather trivial to add support for newer UARTDM
>devices via new compatible fields.
>
>Stephen Boyd (4):
>  msm_serial: Fix NUL byte output on UARTDM
>  msm_serial: Fix sparse warnings
>  msm_serial: Make baud_code detection more dynamic
>  msm_serial: Send more than 1 character at a time on UARTDM
>
> drivers/tty/serial/msm_serial.c | 180 ++++++++++++++++++++--------------------
> drivers/tty/serial/msm_serial.h |  19 ++---
> 2 files changed, 97 insertions(+), 102 deletions(-)

Thanks for these patches.  I'm glad to finally see these issues fixed.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

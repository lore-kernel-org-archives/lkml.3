Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbbAMAYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 19:24:21 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36866 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbbAMAYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 19:24:19 -0500
Message-ID: <54B465B0.6080206@codeaurora.org>
Date: Mon, 12 Jan 2015 16:24:16 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] tty: serial: msm_serial: code cleanup in msm_console_setup
References: <1421070332-24420-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1421070332-24420-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 05:45 AM, Pramod Gurav wrote:
> The change does following:
>  - baud, flow, bits, parity were being overwritten as they were
>    being reinitialized after parsing.  Initialize them when they are
>    declared so that user provided setting are not overwritten.
>  - msm_set_baud_rate() is anyway called in uart_set_options when it calls
>    msm_set_termios(). msm_reset() is called when we change the baud rate.
>    Hence doing away with both of these calls.
>  - CR_CMD_PROTECTION_EN and CR_TX_ENABLE settings are done in msm_set_baud_rate.
>    So do away with this here.
>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project


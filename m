Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaKKCYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:24:03 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58028 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaKKCYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:24:01 -0500
Message-ID: <5461733F.4040402@codeaurora.org>
Date: Mon, 10 Nov 2014 18:23:59 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <545C4E1F.4060401@gmail.com> <54617251.10306@gmail.com>
In-Reply-To: <54617251.10306@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 06:20 PM, Frank Rowand wrote:
> From: Frank Rowand <frank.rowand@sonymobile.com>
>
> v2, changes from v1:
>   - The patch this documents was updated to make the serialN alias
>     optional instead of required.

Not sure we want this v2 vs v1 part, but

>
> Update devicetree binding for msm_serial to reflect msm_serial_probe()
> getting line id from the serial alias.
>
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaDBOLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:11:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54656 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaDBOLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:11:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533C1A7C.1070101@roeck-us.net>
Date: Wed, 02 Apr 2014 07:11:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, wim@iguana.be, shawn.guo@linaro.org,
        linux-watchdog@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/2] watchdog: imx2_wdt: convert to use regmap API.
References: <1396327598-28535-1-git-send-email-Li.Xiubo@freescale.com> <1396327598-28535-3-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1396327598-28535-3-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 09:46 PM, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> ---

Agreed with the other e-mail (an explanation would be useful).
Other than that, looks good to me.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>



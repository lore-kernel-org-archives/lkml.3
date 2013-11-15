Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab3KODmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 22:42:20 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41808 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3KODmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 22:42:12 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAF3f9ui008434, This message is accepted by code: ctloc85258
Message-ID: <52859845.2020101@realsil.com.cn>
Date: Fri, 15 Nov 2013 11:43:01 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
CC: <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4] mfd: rtsx: Generify call-back operations in orderto reduce code duplication
References: <1384421355-4434-1-git-send-email-lee.jones@linaro.org> <1384421355-4434-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1384421355-4434-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 05:29 PM, Lee Jones wrote:
> +	if (rtl8411b_is_qfn48(pcr))
> +		set_pull_ctrl_tables(rtl8411b_qfn48);
> +	else
> +		set_pull_ctrl_tables(rtl8411b_qfn64);
Here will cause some problem, set_pull_ctrl_tables() include not a single
statements, will make the if-else not work correctly.

-- 
Best Regards
Micky.


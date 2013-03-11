Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3CKP1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:27:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51491 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3CKP1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:27:50 -0400
Message-ID: <513DF856.7070400@ti.com>
Date: Mon, 11 Mar 2013 20:59:26 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] ARM: OMAP2+: Divorce from local timer API
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org> <1362614646-24113-5-git-send-email-sboyd@codeaurora.org> <20130308195058.GH11806@atomide.com>
In-Reply-To: <20130308195058.GH11806@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 March 2013 01:20 AM, Tony Lindgren wrote:
> * Stephen Boyd <sboyd@codeaurora.org> [130306 16:22]:
>> Now that the TWD doesn't rely on the local timer API, OMAP can
>> stop selecting it in Kconfig and relying on the config option to
>> decide if it should call smp_twd functions.
>>

> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


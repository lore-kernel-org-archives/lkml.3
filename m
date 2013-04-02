Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063Ab3DBIQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:16:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57001 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759899Ab3DBIQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:16:32 -0400
Message-ID: <515A93C5.4040009@ti.com>
Date: Tue, 2 Apr 2013 13:46:05 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <jacmet@sunsite.dk>
Subject: Re: [PATCH v3 2/3] arm: davinci: clock node support for ECAP & EHRPWM
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com> <1364197789-16783-3-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1364197789-16783-3-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2013 1:19 PM, Philip Avinash wrote:
> Add clock node support for ECAP and EHRPWM modules.
> Also adds TBCLK for EHRWPM TBCLK to comply with pwm-tiehrpwm
> driver.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Queuing this for v3.10

Thanks,
Sekhar

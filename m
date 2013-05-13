Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3EMPIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:08:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60039 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3EMPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:08:04 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 13 May 2013 08:08:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: hdegoede@redhat.com, khali@linux-fr.org, yongjun_wei@trendmicro.com.cn,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: fix error return code in abituguru_probe()
Message-ID: <20130513150818.GB4795@roeck-us.net>
References: <CAPgLHd87mUGwSfX31YLLkL-+72AcrW6szwZiqbfqRZvfvFHBDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd87mUGwSfX31YLLkL-+72AcrW6szwZiqbfqRZvfvFHBDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 02:01:43PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied.

Thanks,
Guenter

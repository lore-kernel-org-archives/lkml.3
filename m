Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3IBJ0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:26:10 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:63888 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3IBJ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:26:07 -0400
Message-ID: <522459AE.3040201@linaro.org>
Date: Mon, 02 Sep 2013 11:26:06 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] intel_idle: mark states tables with __initdata tag
References: <3627555.yC4BdJJnVe@amdc1032>
In-Reply-To: <3627555.yC4BdJJnVe@amdc1032>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

:0
:0
On 08/30/2013 12:26 PM, Bartlomiej Zolnierkiewicz wrote:
> States tables are only accessed during driver initialization so they
> can be marked with __initdata tag.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Len Brown <lenb@kernel.org>
> ---

Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


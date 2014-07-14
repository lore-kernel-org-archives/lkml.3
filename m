Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaGNJKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:10:06 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49784 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaGNJKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:10:01 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] drivers/pwm/Kconfig: Let PWM_CLPS711X depend on HAS_IOMEM
From: Chen Gang <gang.chen.5i5j@gmail.com>
In-Reply-To: <20140714081843.GK2081@ulmo>
Date: Mon, 14 Jul 2014 17:14:05 +0800
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6A7CA9C8-7BC4-44BA-AE71-63BDADFF9023@gmail.com>
References: <53C27247.2010300@gmail.com> <20140714081843.GK2081@ulmo>
To: Thierry Reding <thierry.reding@gmail.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014年7月14日，下午4:18，Thierry Reding <thierry.reding@gmail.com> 写道：

> On Sun, Jul 13, 2014 at 07:49:27PM +0800, Chen Gang wrote:
>> PWM_CLPS711X needs HAS_IOMEM, so let it depend on HAS_IOMEM.
>> 
>> The related error (with allmodconfig under score):
>> 
>>    MODPOST 1365 modules
>>  ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined!
>> 
>> 
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>> drivers/pwm/Kconfig | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> NAK given the discussion in the other thread.
> 
> Thierry

OK, thanks, and I shall continue focusing the other thread, and send related patch after
get conclusion (hope I can finish within this week).

Thanks
—
Chen Gang
Open share, and attitude like air water, and life which God blessed.
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaBBAYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:24:01 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52970 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaBBAYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:24:00 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52ED901F.3010002@roeck-us.net>
Date: Sat, 01 Feb 2014 16:23:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: Would devm_regulator_enable be useful ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

while working with regulators, I noticed that there is no devm_regulator_enable() API.

Seems to me it would be useful to have it, but then devm_clk_enable() doesn't exist either,
so I wonder if there is a reason for not having it.

I'll be happy to submit a patch if people think it is useful; on the other side,
I would like to understand the reason for not having it if there is one.

Thanks,
Guenter

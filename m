Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802Ab3IDQ0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:26:51 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35633 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934851Ab3IDQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <5227355C.1020205@ti.com>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
	<1378276263-10735-7-git-send-email-sachin.kamat@linaro.org>
	<5227355C.1020205@ti.com>
Date: Wed, 4 Sep 2013 21:56:49 +0530
Message-ID: <CAK9yfHxyyZ8WGL8Q4cJ7Y=LcJ2dkeZamXydnMYS4uOj-cmU_Dg@mail.gmail.com>
Subject: Re: [PATCH 7/7] regulator: ti-abb: Use devm_regulator_register
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, gg@slimlogic.co.uk,
        yong.shen@linaro.org, Sascha Hauer <s.hauer@pengutronix.de>,
        marek.vasut@gmail.com, Nancy.Chen@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Nishanth,

On 4 September 2013 18:57, Nishanth Menon <nm@ti.com> wrote:
> On 09/04/2013 01:31 AM, Sachin Kamat wrote:
>> -err:
>> -     dev_err(dev, "%s: Failed to initialize(%d)\n", __func__, ret);
>> -     return ret;
> here -> with this, the lazy non detailed prints end with a generic
> fail case.

Generally when a driver is converted to use devm_* APIs, the error
handling code gets
refactored and simplified as several unwinding calls get removed. The
above print was similarly removed as part
of the cleanup and refactoring as it did not add any extra value.
Probe failure is reported even without this error
message.

-- 
With warm regards,
Sachin

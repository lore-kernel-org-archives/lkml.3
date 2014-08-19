Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaHSMnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:43:39 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:57529 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaHSMnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <53F3351C.1020500@collabora.co.uk>
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>
	<CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>
	<20140814151958.GY17528@sirena.org.uk>
	<CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
	<53EDBB5B.4000209@collabora.co.uk>
	<20140815095528.GH17528@sirena.org.uk>
	<CAPDyKFpm5nzXp5p0qxDof2NcOML911eYkjPNMsn9a2ttdnW7gQ@mail.gmail.com>
	<53F3351C.1020500@collabora.co.uk>
Date: Tue, 19 Aug 2014 14:43:36 +0200
Message-ID: <CAPDyKFrW1ZojV0sWTswapWDvkmgshtyb=NP9CrY+GymdQeRq5w@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask is empty.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Tim Kryger <tim.kryger@gmail.com>,
        Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2014 13:29, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Hello Ulf,
>
> On 08/15/2014 04:51 PM, Ulf Hansson wrote:
>>
>> Just wanted to add some input regarding the errors in the mmc case.
>> These are of high importance. In principle if you get, "Failed getting
>> OCR mask: -22", likely you will be using a wrong OCR mask while
>> negotiating the voltage level with the card.
>>
>> So, somehow we need to address this issue.
>>
>
> And do you think that $subject is the right approach to solve this issue?
> If not please let me know so I can address that.

Well, currently this seems like the best approach. If we end up having
some new regulator helper function, future wise, we can convert to
such later on.

Kind regards
Uffe

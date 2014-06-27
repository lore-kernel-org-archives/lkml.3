Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaF0Sr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:47:58 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41696 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaF0Srz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:47:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140627123109.GA29156@katana>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
	<1403115247-8853-8-git-send-email-dianders@chromium.org>
	<20140627123109.GA29156@katana>
Date: Fri, 27 Jun 2014 11:47:55 -0700
Message-ID: <CAKdAkRRuG2sAbwD+WU-w95AkLsHC7CBHmB60+rLn=ZqhSUF+sA@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] mfd: cros_ec: cleanup: Remove EC wrapper functions
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Doug Anderson <dianders@chromium.org>, Lee Jones <lee.jones@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Simon Glass <sjg@chromium.org>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 5:31 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Wed, Jun 18, 2014 at 11:14:04AM -0700, Doug Anderson wrote:
>> From: Bill Richardson <wfrichar@chromium.org>
>>
>> Remove the three wrapper functions that talk to the EC without passing all
>> the desired arguments and just use the underlying communication function
>> that passes everything in a struct intead.
>>
>> This is internal code refactoring only. Nothing should change.
>>
>> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>> Reviewed-by: Simon Glass <sjg@chromium.org>
>
> For the I2C part:
>
> Acked-by: Wolfram Sang <wsa@the-dreams.de>
>

I'm good with input bits as well.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbaKRP3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:29:20 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60529 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbaKRP3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:29:17 -0500
MIME-Version: 1.0
In-Reply-To: <20141118151927.GG30004@katana>
References: <1415907123-4318-1-git-send-email-b.galvani@gmail.com>
	<1415907123-4318-4-git-send-email-b.galvani@gmail.com>
	<20141118151927.GG30004@katana>
Date: Tue, 18 Nov 2014 16:29:13 +0100
X-Google-Sender-Auth: nwTJP7ljTC1EFZzDfJy2HYFbNEw
Message-ID: <CAOQ7t2Yw5h61xWf2MW11Zsz5_gnv==ihB7Swj=yqcYc=J166gw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ARM: dts: meson: add I2C controller nodes
From: Carlo Caione <carlo@caione.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Beniamino Galvani <b.galvani@gmail.com>, Carlo Caione <carlo@caione.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 4:19 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Thu, Nov 13, 2014 at 08:32:03PM +0100, Beniamino Galvani wrote:
>> Add nodes for I2C controllers A,B,AO, which are available in both
>> Meson6 and Meson8.
>>
>> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
>> ---
>
> I usually don't take DTS patches. They should go via arm-soc. Please say
> so if there are reasons I should take it.

I'll take them.

-- 
Carlo Caione

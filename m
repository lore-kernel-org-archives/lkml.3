Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3IPKSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:18:39 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:60313 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352Ab3IPKSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:18:38 -0400
From: Denis CIOCCA <denis.ciocca@st.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Date: Mon, 16 Sep 2013 12:18:05 +0200
Subject: Re: [PATCH 38/38] iio: magn-core: st: Provide support for the
 LSM303DLH
Thread-Topic: [PATCH 38/38] iio: magn-core: st: Provide support for the
 LSM303DLH
Thread-Index: Ac6yxgpAn0pbHD62Q1ucIBxV7k8GvA==
Message-ID: <5236DADD.3040205@st.com>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-39-git-send-email-lee.jones@linaro.org>
 <5234A28D.1030409@kernel.org> <20130916073151.GB3999@lee--X1>
 <5236D03D.2030506@st.com> <20130916100809.GI3999@lee--X1>
In-Reply-To: <20130916100809.GI3999@lee--X1>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
acceptlanguage: it-IT, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8GAJ08Z003304

Hi Lee,

> The driver mentions that the first group of sensors have a WAI of 
> 0x3c: #define ST_MAGN_1_WAI_EXP 0x3c And when I print out the WAI read 
> from the device: Requested device: lsm303dlh_magn - read WAI: 0x3c I 
> guess I could have been lied to again by the board's datasheet again 
> and the attached device isn't actually a LSM303DLH, but how can I tell 
> for sure? 
On LSM303DLH you have to read 0x0a 0x0b and 0x0c registers, you have to 
find 0x48, 0x34 and 0x33. I think in the snowball there is the LSM303DLHC.

Denisÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

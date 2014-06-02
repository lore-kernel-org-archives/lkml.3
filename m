Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaFBUZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:25:31 -0400
Received: from mout.perfora.net ([74.208.4.194]:60846 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbaFBUZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:25:28 -0400
Message-ID: <538CDD89.6080605@ziswiler.com>
Date: Mon, 02 Jun 2014 22:24:41 +0200
From: Marcel Ziswiler <marcel@ziswiler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 3/3] arm: tegra: initial support for apalis t30
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <b470c9c8631a6ef021d140192eb07006de3cfd93.1401665237.git.marcel@ziswiler.com> <538CA749.3010106@wwwdotorg.org>
In-Reply-To: <538CA749.3010106@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:dEk1pUB0i1ZmHI7WXoBO4Ql6JvB+NJACuf9cBwDEQQr
 rNXEYbWKFNLPsZ2YIycLs73GT/5uWI9zCcZ3MQZGXvwk7A1F5I
 Tqb0vzlBnbncCRxFD9NVVnM2HK/2XvF5mbz3xE7qfqUvoouLaf
 og9CWyOMwq6AzEKPgMmRsXIxBcTD5/x/DyGd/AzTHPv5dlVUkE
 AyhkJIWpw7sb+/BnzT8+nByyhLZWCq3bh+Spvk7B0H3zn13uBZ
 jAI8wc1WT6Ksasf3vZFFdr/jdLOf/O5slf+qNYd6ihPak9U/Nl
 mdEjWnSv09nJQvSrbPtWkofkev7Dz/c0YXuLY4lJmCrDP0nLxt
 oj27vqwR6u88/HSf69qc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 06:33 PM, Stephen Warren wrote:
> I vaguely recall people speaking out against including "spidev" devices
> in DT because they don't represent actual HW, but rather a way to
> request that the SPI bus be exposed to user-space, which is a pure SW
> issue. Wouldn't it be better if the spidev interface worked like
> I2C_CHARDEV, where fake devices weren't actually required?

Well, there is one important difference. While I2C indeed does not have 
any further hardware dependency apart from the clock (SCL) and data 
(SDA) lines SPI actually requires dedicated hardware chip-select lines 
as well. But I guess NVIDIA has been rather ignorant about any of this 
in the past...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3K0PWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:22:35 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:54886 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3K0PWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:22:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Wed, 27 Nov 2013 16:26:12 +0100
From: Stefan Agner <stefan@agner.ch>
To: Lee Jones <lee.jones@linaro.org>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, sameo@linux.intel.com,
        dev@lynxeye.de, mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] mfd: tps6586x: add version detection
In-Reply-To: <20131127143641.GO3296@lee--X1>
References: <cover.1385508112.git.stefan@agner.ch>
 <ef881d39f78b75b4badeebb5be0264edc3906d86.1385508112.git.stefan@agner.ch>
 <20131127130954.GF3296@lee--X1> <cd69295e946b48451f449eacc02efa4a@agner.ch>
 <20131127135547.GK3296@lee--X1> <cfb203a896eda67c106794d89e668d56@agner.ch>
 <20131127143429.GN3296@lee--X1> <20131127143641.GO3296@lee--X1>
Message-ID: <c26ecd550e9940ead950f3874d27a5b0@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-11-27 15:36, schrieb Lee Jones:
<snip>
>> Perhaps I should suggest to make TPS6586X_ANY a positive number then,
>> as a negative value to me indicates more of an error than a generic
>> parameter.
I see, its especially confusing since the version is filled using the
i2c_smbus_read_byte_data functions return value. The version field is a
8-Bit value according to the data sheet, I could use 0x100 as
TPS6586X_ANY identifier.

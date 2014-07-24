Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbaGXNia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:38:30 -0400
Received: from router.aksignal.cz ([188.175.113.102]:44496 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966AbaGXNi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:38:29 -0400
Message-ID: <53D10C50.50305@aksignal.cz>
Date: Thu, 24 Jul 2014 15:38:24 +0200
From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, nicolas.ferre@atmel.com,
        boris.brezillon@free-electrons.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
Content-Type: multipart/mixed;
 boundary="------------050705080605090202000108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050705080605090202000108
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

After ROMBOOT tries boot from flash on SPI0 NPCS0, this NPCS0 (PA14) remains set to PERIPH_A.
Because of that, this pin is unusable to something else.
This patch sets it back to GPIO.

Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>


--------------050705080605090202000108
Content-Type: text/plain; charset=UTF-8;
 name="patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch"

LS0tIGEvbGludXgtMy4xNi1yYzYvYXJjaC9hcm0vYm9vdC9kdHMvYXQ5MXNhbTl4NS5kdHNp
CisrKyBiL2xpbnV4LTMuMTYtcmM2L2FyY2gvYXJtL2Jvb3QvZHRzL2F0OTFzYW05eDUuZHRz
aQpAQCAtNjI0LDcgKzYyNCw4IEBACiAJCQkJCQlhdG1lbCxwaW5zID0KIAkJCQkJCQk8QVQ5
MV9QSU9BIDExIEFUOTFfUEVSSVBIX0EgQVQ5MV9QSU5DVFJMX05PTkUJLyogUEExMSBwZXJp
cGggQSBTUEkwX01JU08gcGluICovCiAJCQkJCQkJIEFUOTFfUElPQSAxMiBBVDkxX1BFUklQ
SF9BIEFUOTFfUElOQ1RSTF9OT05FCS8qIFBBMTIgcGVyaXBoIEEgU1BJMF9NT1NJIHBpbiAq
LwotCQkJCQkJCSBBVDkxX1BJT0EgMTMgQVQ5MV9QRVJJUEhfQSBBVDkxX1BJTkNUUkxfTk9O
RT47CS8qIFBBMTMgcGVyaXBoIEEgU1BJMF9TUENLIHBpbiAqLworCQkJCQkJCSBBVDkxX1BJ
T0EgMTMgQVQ5MV9QRVJJUEhfQSBBVDkxX1BJTkNUUkxfTk9ORQkvKiBQQTEzIHBlcmlwaCBB
IFNQSTBfU1BDSyBwaW4gKi8KKwkJCQkJCQkgQVQ5MV9QSU9BIDE0IEFUOTFfUEVSSVBIX0dQ
SU8gQVQ5MV9QSU5DVFJMX05PTkU+OyAvKiBzZXQgZnJvbSBST01CT09UIHRvIHBlcmlwaCBB
ICovCiAJCQkJCX07CiAJCQkJfTsKCg==
--------------050705080605090202000108--

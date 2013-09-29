Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab3I2SKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 14:10:37 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:54592 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3I2SKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 14:10:35 -0400
Message-ID: <52486D13.1000800@elopez.com.ar>
Date: Sun, 29 Sep 2013 15:10:27 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: herbert@gondor.hengli.com.au, David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Getting started with crypto drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I would like to write a driver to support the "Security System" hardware 
block on some Allwinner ARM SoCs. The hardware supports AES, DES, 3DES, 
SHA-1, MD5 and has a PRNG. Data passing is done via two FIFOs. You can 
find some ugly userspace code to calculate a SHA1 hash here, so you can 
get an idea of how it works:

http://git.elopez.com.ar/ss-poc/raw/31c57d893ce8913aa0d87c982f5350433fbe89c7/md5-tool.c

My main issue at the moment is that I do not have any experience working 
with the crypto API, and that I found the documentation on 
Documentation/ lacking for my purposes. I'd be very grateful if you 
could suggest me reading material to understand the "hardware-oriented" 
API better, and if you could point me to good drivers I could use as an 
example when developing my own.

Thanks!

Emilio

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbbAVVUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:20:40 -0500
Received: from mail.eperm.de ([89.247.134.16]:60108 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbbAVVUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:20:38 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Thu, 22 Jan 2015 22:20:30 +0100
Message-ID: <1876694.bQrN48MF7q@tauon>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54C1403D.1010608@intel.com>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <40625395.stBBYbAQtz@tachyon.chronox.de> <54C1403D.1010608@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 22. Januar 2015, 10:23:57 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 01/20/2015 05:25 PM, Stephan Mueller wrote:
>>> Rather than adding a bogus setkey function, please fix this mess
>>> properly by moving the top-level setkey function into the __driver
>>> one where it should be.  Compare with how we handle it in the
>>> ablk_helper which is pretty much the same thing.
>> 
>> Tadeusz, are you working on that update or shall I have a look?
>
>Hi,
>No, I thought that the agreement was that we don't want to allow user
>space to use these helpers directly, right? Am I missing something?


That would be correct. But if I understood Herbert correctly, he is 
creating a patch that disables these service ciphers for general usage.

Ciao
Stephan

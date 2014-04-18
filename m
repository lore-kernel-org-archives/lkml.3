Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaDRFCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 01:02:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34865 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaDRFB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 01:01:58 -0400
Message-ID: <5350B1B3.9010902@zytor.com>
Date: Thu, 17 Apr 2014 22:01:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Marek Vasut <marex@denx.de>, Jianyu Zhan <nasa4836@gmail.com>,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sha{256,512}_ssse3 - remove asmlinkage from static
 functions
References: <1397665190-12491-1-git-send-email-nasa4836@gmail.com> <201404171728.41994.marex@denx.de> <5350AEF4.9060905@zytor.com> <20140418045828.GA31103@gondor.apana.org.au>
In-Reply-To: <20140418045828.GA31103@gondor.apana.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 09:58 PM, Herbert Xu wrote:
>>
>> It doesn't make sense, sorry.  The right thing to drop here is not
>> "asmlinkage", it is "static": this is an external declaration.
> 
> It's a function pointer that's static, not the function that
> it's pointing to.
> 

{facepalm} Right, function *pointer*.

Duh.

	-hpa



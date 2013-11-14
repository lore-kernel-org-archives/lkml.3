Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3KNSe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:34:26 -0500
Received: from mail.eperm.de ([89.247.134.16]:37334 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab3KNSeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:34:18 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Thu, 14 Nov 2013 19:34:04 +0100
Message-ID: <1442638.aGWDm8aNpM@tauon>
User-Agent: KMail/4.11.3 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <528516BE.2040204@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <3127174.i8ueAho43m@tauon> <528516BE.2040204@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 14. November 2013, 19:30:22 schrieb Clemens Ladisch:

Hi Clemens,

>Stephan Mueller wrote:
>> Am Donnerstag, 14. November 2013, 11:51:03 schrieb Clemens Ladisch:
>>> An attacker would not try to detect patterns; he would apply
>>> knowledge
>>> of the internals.
>> 
>> I do not buy that argument, because if an attacker can detect or
>> deduce the internals of the CPU, he surely can detect the state of
>> the input_pool or the other entropy pools behind /dev/random.
>
>With "internals", I do not mean the actual state of the CPU, but the
>behaviour of all the CPU's execution engines.
>
>An Intel engineer might know how to affect the CPU so that the CPU
>jitter code measures a deterministic pattern, but he will not know the
>contents of my memory.

Here I agree fully.
>
>>> Statistical tests are useful only for detecting the absence of
>>> entropy, not for the opposite.
>> 
>> Again, I fully agree. But it is equally important to understand that
>> entropy is relative.
>
>In cryptography, we care about absolute entropy, i.e., _nobody_ must be
>able to predict the RNG output, not even any CPU engineer.

With your clarification above, I agree here fully.

And now my task is to verify the root cause which I seem to have found.

Let me do my homework.

Ciao
Stephan

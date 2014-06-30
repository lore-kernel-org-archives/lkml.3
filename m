Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaF3OIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:08:31 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:46808 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaF3OI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <mvmr4264i1p.fsf@hawking.suse.de>
References: <mvmvbri4k06.fsf@hawking.suse.de>
	<CAKv+Gu-NAVjMR-Jkw=W-8f7M5FSsQOSdzYN6A0kHDd1m0WA8EA@mail.gmail.com>
	<mvmr4264i1p.fsf@hawking.suse.de>
Date: Mon, 30 Jun 2014 16:08:28 +0200
Message-ID: <CAKv+Gu8SbM_Z=ymBFb2D4EWJeo-6dWuKqE2YNOkqJTKLDEJcYA@mail.gmail.com>
Subject: Re: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andreas Schwab <schwab@suse.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2014 15:56, Andreas Schwab <schwab@suse.de> wrote:
> Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:
>
>> Out of curiosity, how did you trigger this failure? I have build this
>> code numerous times (and so have others) and I have never seen this
>> failure.
>
> Did you ever start with a clean tree?
>

Yep, building both in-tree and out-of-tree, no trouble at all.

-- 
Ard.

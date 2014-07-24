Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbaGXM3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:29:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbaGXM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:29:47 -0400
From: Andreas Schwab <schwab@suse.de>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
References: <mvmvbri4k06.fsf@hawking.suse.de>
	<CAKv+Gu-NAVjMR-Jkw=W-8f7M5FSsQOSdzYN6A0kHDd1m0WA8EA@mail.gmail.com>
	<mvmr4264i1p.fsf@hawking.suse.de>
	<CAKv+Gu8SbM_Z=ymBFb2D4EWJeo-6dWuKqE2YNOkqJTKLDEJcYA@mail.gmail.com>
X-Yow: I want a VEGETARIAN BURRITO to go..  with EXTRA MSG!!
Date: Thu, 24 Jul 2014 14:29:46 +0200
In-Reply-To: <CAKv+Gu8SbM_Z=ymBFb2D4EWJeo-6dWuKqE2YNOkqJTKLDEJcYA@mail.gmail.com>
	(Ard Biesheuvel's message of "Mon, 30 Jun 2014 16:08:28 +0200")
Message-ID: <mvm4my7j5xh.fsf@hawking.suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:

> On 30 June 2014 15:56, Andreas Schwab <schwab@suse.de> wrote:
>> Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:
>>
>>> Out of curiosity, how did you trigger this failure? I have build this
>>> code numerous times (and so have others) and I have never seen this
>>> failure.
>>
>> Did you ever start with a clean tree?
>>
>
> Yep, building both in-tree and out-of-tree, no trouble at all.

So you probably didn't configure them as modules.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbaGXNkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:40:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759119AbaGXNkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:40:05 -0400
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
	<mvm4my7j5xh.fsf@hawking.suse.de>
	<CAKv+Gu-6rUxUnF+dRuroDJqy2K2B5F0r7_bm0X-vyiuQ-83W5w@mail.gmail.com>
	<CAKv+Gu96k7GOVR85EXtro3Lt0jjiJqxyvT9cwJZ1qc6uzq97bw@mail.gmail.com>
	<mvmvbqmj3b2.fsf@hawking.suse.de>
	<CAKv+Gu_9HRwAxkJjT3KRvDbupp0yzstyq1dXsXkTu9M6swdCKQ@mail.gmail.com>
X-Yow: He is the MELBA-BEING...  the ANGEL CAKE...
  XEROX him...  XEROX him --
Date: Thu, 24 Jul 2014 15:40:04 +0200
In-Reply-To: <CAKv+Gu_9HRwAxkJjT3KRvDbupp0yzstyq1dXsXkTu9M6swdCKQ@mail.gmail.com>
	(Ard Biesheuvel's message of "Thu, 24 Jul 2014 15:29:57 +0200")
Message-ID: <mvmr41aj2ob.fsf@hawking.suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:

> On 24 July 2014 15:26, Andreas Schwab <schwab@suse.de> wrote:
>> You are not using CONFIG_MODVERSIONS.
>>
>
> I am

No, you aren't, since you say that your .cmd contains a command to
create aes-glue-ce.o, which with CONFIG_MODVERSIONS it doesn't.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."

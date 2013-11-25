Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3KYTDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:03:40 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:41697 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3KYTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:03:37 -0500
X-Auth-Info: RznKF1FUnq6t1KMXRdyWc7fUAJU6eUC7nYxef0nVlxA=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] m68k/amiga: Fix specifying multiple debug= parameters
References: <1382039212-26062-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdUUvzc1eGhJjqye7aOcNQoGgOEfT=TDLQgbef6-0vT=qQ@mail.gmail.com>
X-Yow: Why are these athletic shoe salesmen following me??
Date: Mon, 25 Nov 2013 20:03:33 +0100
In-Reply-To: <CAMuHMdUUvzc1eGhJjqye7aOcNQoGgOEfT=TDLQgbef6-0vT=qQ@mail.gmail.com>
	(Geert Uytterhoeven's message of "Mon, 25 Nov 2013 17:16:10 +0100")
Message-ID: <87fvqkpam2.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

>>   2. Do we want to fix it this way? Alternatives are:
>>        a. Reject a second debug= parameter by checking for a non-NULL .write()
>>           method
>>           => only the first debug console will be used,
>>        b. Skip console registration in case of a non-NULL .write() method
>>           => only the last debug console will be used,
>>   3. Atari has a similar issue, with even more (4) debug consoles.

2b is backward compatible.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

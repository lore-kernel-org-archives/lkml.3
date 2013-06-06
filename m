Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3FFQwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:52:30 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52595 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3FFQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:52:28 -0400
X-Auth-Info: 1csBRn0w/ZOBIt++DXDgd+Or27s2F52fChsr1MkMX68=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc: avoid strncpy in accounting tool
References: <20130606024930.GA24279@www.outflux.net>
X-Yow: Clear the laundromat!!  This whirl-o-matic just had a nuclear meltdown!!
Date: Thu, 06 Jun 2013 18:52:17 +0200
In-Reply-To: <20130606024930.GA24279@www.outflux.net> (Kees Cook's message of
	"Wed, 5 Jun 2013 19:49:30 -0700")
Message-ID: <87fvwvqj0e.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> Avoid strncpy anti-pattern. Use strdup() instead, as already done for
> the logfile optarg.

There should be no need to copy the string, option arguments are stable.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

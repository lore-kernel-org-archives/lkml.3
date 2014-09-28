Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaI1Jk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:40:57 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52375 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaI1Jk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:40:56 -0400
X-Auth-Info: DFdfmqssx5UVqG6dyl624/v43rm/F0I0e7sDPlD5uTk/1qmIRb47uTeO1TLrD6RD
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()
References: <1411896385-25384-1-git-send-email-geert@linux-m68k.org>
X-Yow: I'm an East Side TYPE..
Date: Sun, 28 Sep 2014 11:40:51 +0200
In-Reply-To: <1411896385-25384-1-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Sun, 28 Sep 2014 11:26:21 +0200")
Message-ID: <m2oau09j6k.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> While most callers run early, before interrupt are disabled, or

                                       interrupts are enabled

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

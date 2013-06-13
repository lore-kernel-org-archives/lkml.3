Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3FMMZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:25:32 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33179 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab3FMMZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:25:30 -0400
X-Auth-Info: i1IOr6FbMm7wkW4EtCWXDdHMTqeZPjrvKqm9+q1LpP4=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/uaccess: Fix asm constraints for userspace access
References: <1371124784-13306-1-git-send-email-geert@linux-m68k.org>
X-Yow: I know how to get the hostesses released!  Give them their own
 television series!
Date: Thu, 13 Jun 2013 14:25:20 +0200
In-Reply-To: <1371124784-13306-1-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Thu, 13 Jun 2013 13:59:44 +0200")
Message-ID: <mvm7ghyrydr.fsf@hawking.suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Also, relax the asm constraints for 16-bit userspace accesses in
> __put_user() and __get_user(), as both "move" and "moves" do support
> such transfers between memory and address registers.

There's another occurrence in __constant_copy_from_user and
__constant_copy_to_user.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

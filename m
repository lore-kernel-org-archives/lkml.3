Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaFYWrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:47:17 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:44824 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaFYWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:47:16 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] lib: list_sort: Various minor improvements
Organization: D03
References: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140625145314.3e16af6998765b7aad860bf7@linux-foundation.org>
	<87egycoc8t.fsf@rasmusvillemoes.dk>
	<20140625153246.3d3dbda781ce1af5524269ab@linux-foundation.org>
X-Hashcash: 1:20:140625:don.mullis@gmail.com::X6Iyv9pXxogpUHKH:000000000000000000000000000000000000000000OrG
X-Hashcash: 1:20:140625:akpm@linux-foundation.org::emVNaI2VBpk0ihx3:00000000000000000000000000000000000050gp
X-Hashcash: 1:20:140625:artem.bityutskiy@linux.intel.com::50ecMTCWH9jK+MWm:000000000000000000000000000003k0j
X-Hashcash: 1:20:140625:david@fromorbit.com::uWF9GBJVHoxFgYt9:0000000000000000000000000000000000000000004Wbf
X-Hashcash: 1:20:140625:linux-kernel@vger.kernel.org::miY5u9pW+7m7drXK:0000000000000000000000000000000005nNi
Date: Thu, 26 Jun 2014 00:47:12 +0200
In-Reply-To: <20140625153246.3d3dbda781ce1af5524269ab@linux-foundation.org>
	(Andrew Morton's message of "Wed, 25 Jun 2014 15:32:46 -0700")
Message-ID: <87a990obdb.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 26 Jun 2014 00:28:18 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>
>> Minor comment: Won't this end up saying "list_sort_test: list passed to
>> ...", despite the list coming from a 'real' user? Maybe change the first
>> #define to '"list_sort: " fmt', the above message to "passed list too
>> long for efficiency", and redefine pr_fmt right after #ifdef
>> CONFIG_TEST_LIST_SORT.
>
> Yeah, I was hoping nobody would notice that ;)
>
> How about just
>
> 		printk_once(KERN_DEBUG "list too long for efficiency\n");

FWIW, fine by me.

Rasmus

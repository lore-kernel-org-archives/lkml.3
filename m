Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbaGBRtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:49:23 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:33001 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaGBRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:49:22 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: arcnet: Remove "#define bool int"
Organization: D03
References: <1404303121-2548-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140702160250.GA2658@kroah.com>
X-Hashcash: 1:20:140702:netdev@vger.kernel.org::N5GzqCfcS2uPyjQj:0000000000000000000000000000000000000001LQU
X-Hashcash: 1:20:140702:linux-kernel@vger.kernel.org::cVFfQBqqE0g0Sbcd:0000000000000000000000000000000002FCc
X-Hashcash: 1:20:140702:gregkh@linuxfoundation.org::CRy2rOvOG9oKTlZD:000000000000000000000000000000000001X00
Date: Wed, 02 Jul 2014 19:49:17 +0200
In-Reply-To: <20140702160250.GA2658@kroah.com> (Greg Kroah-Hartman's message
	of "Wed, 2 Jul 2014 09:02:50 -0700")
Message-ID: <87oax7mz1e.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Jul 02, 2014 at 02:12:01PM +0200, Rasmus Villemoes wrote:
>
>>  include/linux/arcdevice.h | 10 +++-------
>>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> Why are you sending this patch to me?  I don't "own" it at all, please
> use scripts/get_maintainer.pl to determine who to email patches to.

Sorry. I did use get_maintainer.pl, but that only produced the two
mailing lists. I thought one was supposed to include at least one
maintainer, so I made a (not-so-)educated guess. I'll try to be more
careful in the future.

Rasmus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3G1C1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 22:27:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51720 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3G1C10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 22:27:26 -0400
Date: Sat, 27 Jul 2013 19:27:25 -0700 (PDT)
Message-Id: <20130727.192725.1220037383953385935.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, odanet@caramail.com
Subject: Re: [ 15/59] sparc32: vm_area_struct access for old Sun SPARCs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374961508.3607.18.camel@deadeye.wl.decadent.org.uk>
References: <20130726205013.795696531@linuxfoundation.org>
	<20130726205015.440894498@linuxfoundation.org>
	<1374961508.3607.18.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 27 Jul 2013 19:27:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sat, 27 Jul 2013 22:45:08 +0100

> On Fri, 2013-07-26 at 13:52 -0700, Greg Kroah-Hartman wrote:
>> 3.4-stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: Olivier DANET <odanet@caramail.com>
> [...]
> 
> This, and the other SPARC fixes for 3.4 and 3.0, are missing upstream
> commit references, which should be:
> 
> [SPARC] sparc32: vm_area_struct access for old Sun SPARCs.
> commit 961246b4ed8da3bcf4ee1eb9147f341013553e3c upstream.
> 
> sparc64 address-congruence property
> commit 771a37ff4d80b80db3b0df3e7696f14b298c67b7 upstream.
> 
> sparc: tsb must be flushed before tlb
> commit 23a01138efe216f8084cfaa74b0b90dd4b097441 upstream.

Sorry, I forgot the upstream commit tags on these Sparc bits.
:-/

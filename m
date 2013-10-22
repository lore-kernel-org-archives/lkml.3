Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3JVRyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:54:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58420 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3JVRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:54:47 -0400
Date: Tue, 22 Oct 2013 13:54:42 -0400 (EDT)
Message-Id: <20131022.135442.1072093301788210177.davem@davemloft.net>
To: aaro.koskinen@iki.fi
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131022174612.GC24448@blackmetal.musicnaut.iki.fi>
References: <20130617055839.GB3073@blackmetal.musicnaut.iki.fi>
	<20130803.134042.2228681844349448961.davem@davemloft.net>
	<20131022174612.GC24448@blackmetal.musicnaut.iki.fi>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 22 Oct 2013 10:54:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Tue, 22 Oct 2013 20:46:12 +0300

> Hi,
> 
> On Sat, Aug 03, 2013 at 01:40:42PM -0700, David Miller wrote:
>> > On Mon, Jun 17, 2013 at 08:32:25AM +0300, Aaro Koskinen wrote:
>> >> On Mon, Jun 17, 2013 at 12:06:00AM +0300, Meelis Roos wrote:
>> >> > Got this in 3.10-rc6 whil testing debian unstable upgrade with aptitude. 
>> >> > 3.10-rc5 did not exhibit this (nor any other kernel recently tried, 
>> >> > including most -rc's). Does not seem to be reproducible.
>> >> 
>> >> I get this regularly on Ultrasparc during long compilations. It's been
>> >> there with all recent kernels (probably at least since 3.8). Latest I
>> >> saw with 3.10-rc5.
>> > 
>> > Two examples:
>> 
>> Thanks for the reports, I'm actively looking into this.
> 
> Got this again with 3.12-rc5 while doing GCC 4.8.2 bootstrap (during
> make check phase):
 ...
> The box didn't die yet... Let's hope it will let GCC testsuite to finish.

Thanks for reporting this again, it's in my long TODO list to look into
still.

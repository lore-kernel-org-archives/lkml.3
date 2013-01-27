Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3A0ONA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:13:00 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63937 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab3A0OM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:12:57 -0500
Date: Sun, 27 Jan 2013 15:12:54 +0100
From: Paolo Pisati <p.pisati@gmail.com>
To: Mats Liljegren <mats.liljegren@enea.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: Re: [BUG] panda board locks up on boot
Message-ID: <20130127141254.GC5714@stinkpad>
References: <1359082886.21576.199.camel@gandalf.local.home>
 <51022FD2.8090101@compulab.co.il>
 <0247700D01F14443B9209F90AD938CC52409708C@sestoex09.enea.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0247700D01F14443B9209F90AD938CC52409708C@sestoex09.enea.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 08:43:15AM +0000, Mats Liljegren wrote:
> Hi Steven,
> 
> Do you have CONFIG_CPU_FREQ enabled? As I posted earlier in linux-kernel forum ("Failed booting PandaBoard ES with Linux 3.8 RC4" two days ago) my PandaBoard ES hangs while booting with this option enabled. It works fine without it. I have not bisected it down to a single commit though.

glad i'm not the only one who hit this problem:

"3.8rc4+ and cpu_freq omap: hangs, oopses, etcetc"

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg83693.html

-- 
bye,
p.

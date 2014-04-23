Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaDWVmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:42:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaDWVmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:42:01 -0400
Date: Wed, 23 Apr 2014 23:41:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
In-Reply-To: <20140423221609.0d3b536f@alan.etchedpixels.co.uk>
Message-ID: <alpine.LRH.2.00.1404232341100.1491@twin.jikos.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz> <1395770101-24534-9-git-send-email-jack@suse.cz> <20140326172332.5f1e1bfb@alan.etchedpixels.co.uk> <20140326192815.GC18118@quack.suse.cz> <20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
 <20140422112259.5f106a44@alan.etchedpixels.co.uk> <20140423110847.GB17824@quack.suse.cz> <20140423111750.88ad799bb271a1fe0bed119f@linux-foundation.org> <20140423221609.0d3b536f@alan.etchedpixels.co.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, One Thousand Gnomes wrote:

> Given this all only affects huge boxes and the only fix we have right 
> now is hideously ugly I'd rather it stayed in the vendor hacks to their 
> trees, until someone is inspired to sort it properly.

I have to say I am rather disappointed by this statement, indirectly 
implying that vanilla kernel doesn't care about booting properly on huge 
boxes.

-- 
Jiri Kosina
SUSE Labs


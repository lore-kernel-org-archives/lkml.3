Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090Ab3IDAVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:21:54 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:37126 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab3IDAVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:21:52 -0400
Date: Wed, 4 Sep 2013 00:21:50 +0000
From: Eric Wong <normalperson@yhbt.net>
To: dormando <dormando@rydia.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ipv4: warnings on sk_wmem_queued
Message-ID: <20130904002150.GA14033@dcvr.yhbt.net>
References: <20130830195638.GA27393@dcvr.yhbt.net>
 <alpine.DEB.2.02.1308311229280.3532@dtop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308311229280.3532@dtop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dormando <dormando@rydia.net> wrote:
> > I noticed these warnings on stock 3.10.9 running stress tests on
> > cmogstored.git (git://bogomips.org/cmogstored.git) doing standard
> > HTTP server stuff between lo and tmpfs:
> >
> [...]
> > I was going to reboot into 3.10.10 before I looked at dmesg.  These
> > warnings happened after ~8 hours of stress tests, and those stress tests
> > are still running.
> 
> I had a kernel panic this morning on a production machine, also running
> 3.10.9. I only got a small part of the end of the trace, but it matches:

I haven't managed to hit any kernel panic nor my original warning again
after all these days of constant 20+ GB/s lo traffic.  I'll finally
reboot into 3.10.10 now.  dmesg has been completely quiet since the warning
and the machine is still running well.

> (also: hi Eric!)

Hi dormando!

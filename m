Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaB0Dpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:45:38 -0500
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:57838
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaB0Dph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:45:37 -0500
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=Rs1LLUWK c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=M1kyBYkWWGkA:10 a=IVxCAUdSCW8A:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=S4CjxF9jpiAA:10
 a=RL_Ok0Oeo2eSE6IprA8A:9 a=QEXdDO2ut3YA:10 a=6siWUdW7VbcA:10 a=oEDgWFgnZy0A:10
Date: Thu, 27 Feb 2014 03:45:35 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
Message-ID: <20140227034535.GC14346@milliways>
References: <20140227005246.GB10367@milliways>
 <1393471595.5519.22.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393471595.5519.22.camel@marge.simpson.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 04:26:35AM +0100, Mike Galbraith wrote:
> 
> I would start with strace to see if a task is looping in userspace, then
> move on to perf top -g -p <pid> (or perf record/report) to peek at what
> it's up to in the kernel.  Once you have the where, trace_printk() is
> the best thing since sliced bread (which ranks just below printk()).
> 
> -Mike
 Thanks.  I'll need to build perf.

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce

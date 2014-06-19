Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbaFSQwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:52:17 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:41822 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716AbaFSQwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:52:14 -0400
Date: Thu, 19 Jun 2014 19:52:05 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG at mm/memory.c
Message-ID: <20140619165205.GA26761@node.dhcp.inet.fi>
References: <53A3102E.2030602@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A3102E.2030602@odi.ch>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 06:30:38PM +0200, Ortwin Glück wrote:
> Hi,
> 
> I was hitting a BUG while running a couple of qemu 2.0 on a 3.15.0 kernel. KSM was running. This box uses NUMA with two E5 6-core Xeons.
> 
> Linux toaster 3.15.0 #1 SMP PREEMPT Thu Jun 12 14:05:12 CEST 2014 x86_64 Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz GenuineIntel GNU/Linux
> 
> Jun 17 16:59:47 toaster kernel: ------------[ cut here ]------------
> Jun 17 16:59:47 toaster kernel: kernel BUG at mm/memory.c:3924!

http://marc.info/?l=linux-kernel&m=140319579508104&w=2

-- 
 Kirill A. Shutemov

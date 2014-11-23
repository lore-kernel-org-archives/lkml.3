Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaKWT3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:29:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:35033 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaKWT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:29:12 -0500
Date: Sun, 23 Nov 2014 20:29:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Fleming <matt@console-pimps.org>
cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, vikas.shivappa@intel.com, hpa@zytor.com,
        mingo@kernel.org, tj@kernel.org, matt.fleming@intel.com,
        will.auld@intel.com, peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
In-Reply-To: <20141123192613.GA2956@console-pimps.org>
Message-ID: <alpine.DEB.2.11.1411232028250.6439@nanos>
References: <alpine.DEB.2.11.1411211224070.6439@nanos> <20141123192613.GA2956@console-pimps.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2014, Matt Fleming wrote:
> Something like this?
> 
> 	first_bit = find_next_bit(map, nr_bits, -1);
> 	zero_bit = find_next_zero_bit(map, nr_bits, first_bit);
> 
> 	if (find_next_bit(map, nr_bits, zero_bit) < nr_bits)
> 		return -EINVAL;	/* non-contiguous bits */

Looks pretty self explaining, right?

Thanks,

	tglx

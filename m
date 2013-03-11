Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3CKUoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab3CKUoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:44:30 -0400
Date: Mon, 11 Mar 2013 16:44:23 -0400
From: Dave Jones <davej@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: torrent hash failures since 3.9.0-rc1
Message-ID: <20130311204423.GA25307@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311201334.GA444@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 09:13:34PM +0100, Markus Trippelsdorf wrote:

 > > Worked fine for me on two separate machines.  Could it be a network problem
 > > perhaps ? If something is mangling the packet before it hits the disk,
 > > that would explain it.  What NIC do you use ?
 > 
 > I normally use ATL1E, but I've dusted off my E100 and the issue is also
 > reproducible on the Intel card.
 
ok, good to rule that out at least.

 > > Or maybe you could isolate it to a filesystem problem using something
 > > like fsx ?
 > 
 > I've found fsx on your homepage, but I've no idea on how to use this
 > tool. Any pointers?

cd to the mount point you want to test, and then 'fsx test' will create
a couple files there, and stress them.

	Dave


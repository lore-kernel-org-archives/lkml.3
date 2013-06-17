Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3FQRkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:40:00 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:40293 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab3FQRjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:39:45 -0400
X-ASG-Debug-ID: 1371490784-0421b502202cde0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130617134955.GB15861@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
References: <20130617134955.GB15861@redhat.com>
Message-ID: <20130617173942.15057.63201@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [3.10-rc6] WARNING: at fs/btrfs/inode.c:7961
 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
Date: Mon, 17 Jun 2013 13:39:42 -0400
X-ASG-Orig-Subj: Re: [3.10-rc6] WARNING: at fs/btrfs/inode.c:7961
 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1371490784
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.134189
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Jones (2013-06-17 09:49:55)
> Hit this while running this script in a loop..
> https://github.com/kernelslacker/io-tests/blob/master/setup.sh
> [34385.251507] ------------[ cut here ]------------
> [34385.254068] WARNING: at fs/btrfs/inode.c:7961 btrfs_destroy_inode+0x265/0x2e0 [btrfs]()

Thanks Dave, how long did you have to run the script to trigger it?

-chris

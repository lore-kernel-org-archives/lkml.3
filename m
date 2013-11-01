Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3KAL5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:57:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab3KAL5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:57:50 -0400
Date: Fri, 1 Nov 2013 12:57:44 +0100
From: Karel Zak <kzak@redhat.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFE?: why no 'bind' info in /proc/mounts?
Message-ID: <20131101115744.GC23604@x2.net.home>
References: <5272FE79.30801@tlinx.org>
 <20131101151521.2fa0b434@notabene.brown>
 <52736B04.6020505@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52736B04.6020505@tlinx.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 01:49:08AM -0700, Linda Walsh wrote:
> 
> 
> Ah... didn't know about the other format file... thanks!

 Or use more user friendly findmnt(8) command:


 # mount --bind /usr/local/bin /mnt/test

 # findmnt  /mnt/test
 TARGET    SOURCE                    FSTYPE OPTIONS
 /mnt/test /dev/sda4[/usr/local/bin] ext4   rw,relatime,data=ordered

    Karel

> On 10/31/2013 9:15 PM, NeilBrown wrote:
> >Take a look in /proc/self/mountinfo.  It contains more useful stuff about the
> >mount table which couldn't be put in /proc/mounts without breaking
> >compatibility.
> >
> >NeilBrown

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

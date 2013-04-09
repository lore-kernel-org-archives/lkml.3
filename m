Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab3DIRm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:42:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49451
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639Ab3DIRm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:42:56 -0400
Date: Tue, 9 Apr 2013 19:42:34 +0200
From: Jens Axboe <axboe@kernel.dk>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Phillip Susi <psusi@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [regression] v3.8 -> v3.9-rc6, caused by commit 8761a3d ("loop:
 cleanup partitions when detaching loop device")
Message-ID: <20130409174234.GL12244@kernel.dk>
References: <87r4ijfxh5.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r4ijfxh5.fsf@nemi.mork.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09 2013, Bjørn Mork wrote:
> Hello,
> 
> the following simple test causes a deadlock between the loop driver,
> umount and blkid i v3.9-rc6 (tested on a standard Debian wheezy
> installating, i.e. with udev 175):
> 
> qmitest:~# file cd-image-cfg1.iso 
> cd-image-cfg1.iso: # ISO 9660 CD-ROM filesystem data 'D-LINK MODEM'
> qmitest:~# mount cd-image-cfg1.iso /mnt/ -oloop,ro -t iso9660
> qmitest:~# umount /mnt 

The pull request is in flight:

https://lkml.org/lkml/2013/4/9/395

so should be in shortly.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945Ab3DIRrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:47:23 -0400
Received: from canardo.mork.no ([148.122.252.1]:36389 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489Ab3DIRrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:47:21 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130409174234.GL12244@kernel.dk>
References: <87r4ijfxh5.fsf@nemi.mork.no> <20130409174234.GL12244@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [regression] v3.8 -> v3.9-rc6, caused by commit 8761a3d ("loop: cleanup partitions when detaching loop device")
From: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Date: Tue, 09 Apr 2013 19:47:06 +0200
To: Jens Axboe <axboe@kernel.dk>
CC: Phillip Susi <psusi@ubuntu.com>, linux-kernel@vger.kernel.org
Message-ID: <59e6eb36-342d-4b20-af14-b21d30449990@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> wrote:

>On Tue, Apr 09 2013, Bjørn Mork wrote:
>> Hello,
>> 
>> the following simple test causes a deadlock between the loop driver,
>> umount and blkid i v3.9-rc6 (tested on a standard Debian wheezy
>> installating, i.e. with udev 175):
>> 
>> qmitest:~# file cd-image-cfg1.iso 
>> cd-image-cfg1.iso: # ISO 9660 CD-ROM filesystem data 'D-LINK MODEM'
>> qmitest:~# mount cd-image-cfg1.iso /mnt/ -oloop,ro -t iso9660
>> qmitest:~# umount /mnt 
>
>The pull request is in flight:
>
>https://lkml.org/lkml/2013/4/9/395
>
>so should be in shortly.

Great! Thanks


Bjørn


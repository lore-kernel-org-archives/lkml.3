Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab3ENVMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419Ab3ENVMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:12:49 -0400
Message-ID: <5192A8CE.30809@redhat.com>
Date: Tue, 14 May 2013 16:12:46 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: v3.10: unmount won't work
References: <51928CB5.2050406@gmx.de>
In-Reply-To: <51928CB5.2050406@gmx.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/13 2:12 PM, Toralf Förster wrote:
> At a stable 32 bit stable Gentoo with kernel v3.10-rc1-113-ga2c7a54 I cannot umount an (EXT4) fs
> which was created in a file located in a tmpfs partition and loop mounted  :
> 
> That file system was used to hold victims files shared via NFSv4 to an user mode linux 
> on which trinity was used to fuzz testing a patched UML guest kernel.
> 
> n22 ~ # mount
> ...
> nfsd on /proc/fs/nfsd type nfsd (rw,nodev,noexec,nosuid)
> /mnt/ramdisk/disk0 on /mnt/trinity type ext4 (rw)

Is your "mount" looking at /etc/mtab ot at /proc/mounts?

What does /proc/mounts say, does it contain this device or mountpoint?

> n22 ~ # umount /mnt/trinity
> umount: /mnt/trinity: not mounted

-Eric


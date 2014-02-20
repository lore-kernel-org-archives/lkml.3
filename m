Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaBTFEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 00:04:05 -0500
Received: from mail.wdtv.com ([66.118.69.84]:42340 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaBTFED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 00:04:03 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Progress, very small, on making a boot.
Date: Thu, 20 Feb 2014 00:03:50 -0500
References: <201402170715.55573.gheskett@wdtv.com> <201402190637.56580.gheskett@wdtv.com> <5304DAED.5040102@infradead.org>
In-Reply-To: <5304DAED.5040102@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402200003.50525.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 February 2014 Randy Dunlap did write:

Lets start with a clean slate here.  See the image from trying to boot 
a 3.13.3 made from the repaired 3.12.9 .config file via an edit to 
re-enable the missing media stuffs followed by a make oldconfig.

Fresh boot pix, not as well focused as I'd like, at the usual link in my
signature. This camera seems not to be able to nail the autofocus dead on
when trying to range find this dell monitors anti-reflective screen and
of course its "available light" so the exposure is a goodly fraction of
a second.

Link in my sig, click on Genes-os9-stf/LCNC/, the .JPG there.

I see two errors, one just a couple lines from the top, and of course the 
non-find of ATA1 stuff that started all this, and at the bottom, an attempt, 
and a fuss over ATA6 which does not even exist.  There are 4 active 1 Tb 
drives, ATA1-ATA4, followed by a sata interfaced dvd writer, ATA5. MoBo 
sockets for SATA6 and SATA7 are empty.

Are we being bamboozled by an off by one error in the sata_nv code? Some
post 3.12.9 patch perhaps?

Should I go get the ChangeLogs and start grepping for sata_nv?

blkid output booted to 3.12.9:
gene@coyote:/opt/Genes-os9-stf/LCNC$ sudo blkid
/dev/sda1: LABEL="ububoot" UUID="f54ba7af-1545-43f3-a86e-bfc0017b4526" SEC_TYPE="ext2" TYPE="ext3" 
/dev/sda2: LABEL="uburoot" UUID="ec677e9c-6be6-4311-b97b-3889d42ce6ef" TYPE="ext4" 
/dev/sda3: UUID="edc2880e-257d-4521-8220-0df5b57dcae4" TYPE="swap" 
/dev/sdb1: UUID="80ab0463-d6fc-4f5b-af08-5aa43d55fdf8" SEC_TYPE="ext2" TYPE="ext3" 
/dev/sdb5: UUID="b4841721-a040-48bc-80dc-e742164ad38a" TYPE="swap" 
/dev/sdc1: UUID="1321fc90-ba7a-4742-8176-f7b3a8284be5" TYPE="ext4" 
/dev/sdc2: LABEL="amandatapes-1-T" UUID="b7657920-d9a2-4379-ae21-08a0651b65cc" SEC_TYPE="ext2" TYPE="ext3" 
/dev/sdd1: LABEL="home2" UUID="7601432d-7a30-42a3-80b5-57f08ae71f2a" TYPE="ext4" 
/dev/sdd2: LABEL="opt2" UUID="748b01e1-ae7b-4b17-b8e9-c88429bcefbf" TYPE="ext4" 
/dev/sr0: LABEL="10-302-50-1" TYPE="iso9660" 

Your thoughts?

Thanks Randy.
Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.


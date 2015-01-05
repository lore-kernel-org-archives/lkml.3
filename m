Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbbAEKG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:06:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbAEKG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:06:57 -0500
Date: Mon, 5 Jan 2015 11:06:52 +0100
From: Jan Kara <jack@suse.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_UDF_FS description
Message-ID: <20150105100652.GD7056@quack.suse.cz>
References: <201412242035.49929@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412242035.49929@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-12-14 20:35:49, Pali Rohár wrote:
  Hello,

> Hello, can you update menuconfig description about UDF filesystem 
> in file fs/udf/Kconfig? There is information only about CD/DVD 
> discs and packet mode. But UDF FS can be used also on hard disks 
> or removable usb disks (as multiplatform alternative to FAT32). 
> It means that CONFIG_UDF_FS can be useful also on machines 
> without optical mechanic.
  Thanks for suggestion. I have updated the text to read as follows:
          This is a file system used on some CD-ROMs and DVDs. Since the
          file system is supported by multiple operating systems and is more
          compatible with standard unix file systems, it is also suitable for
          removable USB disks. Say Y if you intend to mount DVD discs or CDRW's
          written in packet mode, or if you want to use UDF for removable USB
          disks. Please read <file:Documentation/filesystems/udf.txt>.

          To compile this file system support as a module, choose M here: the
          module will be called udf.


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

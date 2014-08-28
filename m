Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaH1WJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:09:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:28117 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaH1WJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:09:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,420,1406617200"; 
   d="scan'208";a="473611426"
From: "Zwisler, Ross" <ross.zwisler@intel.com>
To: "openosd@gmail.com" <openosd@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "willy@linux.intel.com" <willy@linux.intel.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v10 00/21] Support ext4 on NV-DIMMs
Thread-Topic: [PATCH v10 00/21] Support ext4 on NV-DIMMs
Thread-Index: AQHPwwzGjI+p/oSZd0u8kp1kH2GFCg==
Date: Thu, 28 Aug 2014 22:09:45 +0000
Message-ID: <1409263783.27285.7.camel@rzwisler-mobl1.amr.corp.intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
	 <53FEE379.9060204@gmail.com>
In-Reply-To: <53FEE379.9060204@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.112.154]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9DC40E375DCAF47BEAC93C3D4371464@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7SMA4Gi021661

On Thu, 2014-08-28 at 11:08 +0300, Boaz Harrosh wrote:
> On 08/27/2014 06:45 AM, Matthew Wilcox wrote:
> > One of the primary uses for NV-DIMMs is to expose them as a block device
> > and use a filesystem to store files on the NV-DIMM.  While that works,
> > it currently wastes memory and CPU time buffering the files in the page
> > cache.  We have support in ext2 for bypassing the page cache, but it
> > has some races which are unfixable in the current design.  This series
> > of patches rewrite the underlying support, and add support for direct
> > access to ext4.
> > 
> > Note that patch 6/21 has been included in
> > https://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=for-next-candidate
> > 
> 
> Matthew hi
> 
> Could you please push this to the regular or a new public tree?
> 
> (Old versions are at: https://github.com/01org/prd)
> 
> Thanks
> Boaz

Hi Boaz,

I've pushed the updated tree to https://github.com/01org/prd in the master
branch.  All the older versions of the code that we've had while rebasing are
still available in their own branches.

Thanks,
- Ross

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

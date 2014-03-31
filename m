Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaCaXev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:34:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:12240 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaCaXeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:34:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,768,1389772800"; 
   d="scan'208";a="503936357"
Date: Mon, 31 Mar 2014 16:34:50 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
Message-ID: <20140331233450.GI32556@tassilo.jf.intel.com>
References: <52E4CF03.8030208@archlinux.org>
 <5339F739.2060207@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5339F739.2060207@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 01:16:09AM +0200, Thomas Bächler wrote:
> Am 26.01.2014 10:01, schrieb Thomas Bächler:
> > Good morning,
> > 
> > I am trying to build Linux 3.13 on i686 with CONFIG_MODVERSIONS enabled
> > (for configuration, see [2]). Upon booting it in a VM, I discovered that
> > I was unable to load several kernel modules, like ext4:
> > 
> > ext4: disagrees about version of symbol d_tmpfile
> > ext4: Unknown symbol d_tmpfile (err -22)
> > ext4: disagrees about version of symbol iov_shorten
> > ext4: Unknown symbol iov_shorten (err -22)
> > ext4: disagrees about version of symbol in_group_p
> > ext4: Unknown symbol in_group_p (err -22)
> > ext4: disagrees about version of symbol do_sync_read
> > ext4: Unknown symbol do_sync_read (err -22)
> > ext4: disagrees about version of symbol current_fs_time
> > ext4: Unknown symbol current_fs_time (err -22)
> > ext4: disagrees about version of symbol generic_write_sync
> > ext4: Unknown symbol generic_write_sync (err -22)
> > ext4: disagrees about version of symbol generic_getxattr
> > ext4: Unknown symbol generic_getxattr (err -22)
> 
> This problem persists in v3.14, i.e. I still have to revert
> 83460ec8dcac14142e7860a01fa59c267ac4657c in order to get a working
> kernel on i686. I would really appreciate if someone would actually read
> my original mail from about 3 months ago and write an answer.

Can you resend it please?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaFBHyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:54:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:65082 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaFBHys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,955,1392192000"; 
   d="scan'208";a="541103836"
Message-ID: <1401695682.11182.108.camel@sauron.fi.intel.com>
Subject: Re: [RFC 17/32] ubifs: convert to struct inode_time
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        hpa@zytor.com, linux-fsdevel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Date: Mon, 02 Jun 2014 10:54:42 +0300
In-Reply-To: <1401480116-1973111-18-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	 <1401480116-1973111-18-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 22:01 +0200, Arnd Bergmann wrote:
> ubifs uses 64-bit integers for inode timestamps, which will work
> practicall forever, but the VFS uses struct timespec for timestamps,
> which is only good until 2038 on 32-bit CPUs.
> 
> This gets us one small step closer to lifting the VFS limit by using
> struct inode_time in ubifs.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: linux-mtd@lists.infradead.org

Looks fine from UBIFS POW, thanks!

-- 
Best Regards,
Artem Bityutskiy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163286Ab3DFL1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 07:27:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46829 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163238Ab3DFL1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 07:27:03 -0400
Date: Sat, 6 Apr 2013 13:26:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Michael D. Setzer II" <msetzerii@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Error in linux-3.0.72 build.
Message-ID: <20130406112657.GA3625@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Michael D. Setzer II" <msetzerii@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <515FF835.28644.1FF1E@msetzerii.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <515FF835.28644.1FF1E@msetzerii.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 08:25:57PM +1000, Michael D. Setzer II wrote:
> Just downloaded new kernels, and find this error in build.
> 
> fs/built-in.o: In function `find_group_flex':
> /home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:359: undefined 
> reference to `__udivdi3'
> /home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:374: undefined 
> reference to `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1

Looks like your compiler is generating 64-bit division which is a call
into libgcc. Which gcc version are you using?

+ext4 folks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

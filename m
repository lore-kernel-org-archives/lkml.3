Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3CCMA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:00:26 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:54826 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3CCMAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:00:24 -0500
X-ASG-Debug-ID: 1362312023-0421b5454816430001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Sun, 3 Mar 2013 07:00:21 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Chris Mason <clmason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs/raid56: Add missing #include <linux/vmalloc.h>
Message-ID: <20130303120021.GA18135@shiny.masoncoding.com>
X-ASG-Orig-Subj: Re: [PATCH] btrfs/raid56: Add missing #include <linux/vmalloc.h>
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Mason <clmason@fusionio.com>, David Sterba <dsterba@suse.cz>,
	Josef Bacik <JBacik@fusionio.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1362311081-10145-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1362311081-10145-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1362312023
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.124127
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 04:44:41AM -0700, Geert Uytterhoeven wrote:
> tilegx_defconfig:
> 
> fs/btrfs/raid56.c: In function 'btrfs_alloc_stripe_hash_table':
> fs/btrfs/raid56.c:206:3: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
> fs/btrfs/raid56.c:206:9: warning: assignment makes pointer from integer without a cast [enabled by default]
> fs/btrfs/raid56.c:226:4: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]

Thanks, I've got this one in my for-linus now.  It'll go with the next
pull.

-chris

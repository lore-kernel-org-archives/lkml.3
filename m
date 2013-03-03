Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3CCMcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 07:32:53 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:55393 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3CCMcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 07:32:52 -0500
X-ASG-Debug-ID: 1362313971-0421b54549164a0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Sun, 3 Mar 2013 07:32:49 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [GIT PULL] Btrfs fixup
Message-ID: <20130303123249.GB18135@shiny.masoncoding.com>
X-ASG-Orig-Subj: [GIT PULL] Btrfs fixup
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	"JBottomley@parallels.com" <JBottomley@parallels.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1362313971
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.124128
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Geert and James both sent this one in, sorry guys.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Geert Uytterhoeven (1) commits (+1/-0):
    btrfs/raid56: Add missing #include <linux/vmalloc.h>

Total: (1) commits (+1/-0)

 fs/btrfs/raid56.c | 1 +
 1 file changed, 1 insertion(+)

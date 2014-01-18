Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaAWAif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:38:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40029 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaAWAid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:38:33 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140117230219.GA28413@garbanzo.do-not-panic.com>
References: <20140117230219.GA28413@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: MAINTAINERS tree branches [xen tip as an example]
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 17 Jan 2014 21:39:42 -0500
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, xen-devel@lists.xen.org
CC: David Vrabel <david.vrabel@citrix.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Message-ID: <8c3298a9-256a-43c3-8565-6f7fee6e4059@email.android.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
>As per linux-next Next/Trees [0], and a recent January MAINTAINERS
>patch [1]
>from David one of the xen development kernel git trees to track is
>xen/git.git [2], this tree however gives has undefined references when
>doing a
>fresh clone [shown below], but as expected does work well when only
>cloning
>the linux-next branch [also below]. While I'm sure this is fine for
>folks who can do the guess work do we really want to live with trees
>like
>these on MAINTAINERS ? The MAINTAINERS file doesn't let us specify
>branches
>required, so perhaps it should -- if we want to live with these ?

The master branch can be linked to the #linux-next or stable/for-linus.

That would solve the problem I think.
>Curious, how
>many other git are there with a similar situation ?
>
>The xen project web site actually lists [3] Konrad's xen git tree [4]
>for
>development as the primary development tree, that probably should be
>updated now, and likely with instructions to clone only the linux-next
>branch ?

Thank you for reporting. Will fix it next week if nobody else beats me to it.
>
>[0]
>https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Next/Trees#n176
>[1] http://lists.xen.org/archives/html/xen-devel/2014-01/msg01504.html
>[2] git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git
>[3]
>http://wiki.xenproject.org/wiki/Xen_Repositories#Primary_Xen_Repository
>[4] git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
>
>mcgrof@bubbles ~ $ git clone
>git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git --reference
>linux/.git
>Cloning into 'tip'...
>remote: Counting objects: 2806, done.
>remote: Compressing objects: 100% (334/334), done.
>remote: Total 1797 (delta 1511), reused 1646 (delta 1462)
>Receiving objects: 100% (1797/1797), 711.01 KiB | 640.00 KiB/s, done.
>Resolving deltas: 100% (1511/1511), completed with 306 local objects.
>Checking connectivity... done.
>warning: remote HEAD refers to nonexistent ref, unable to checkout.
>
>mcgrof@work ~ $ git clone
>git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git -b linux-next
>--reference linux/.git
>Cloning into 'tip'...
>remote: Counting objects: 2806, done.
>remote: Compressing objects: 100% (377/377), done.
>remote: Total 1797 (delta 1545), reused 1607 (delta 1419)
>Receiving objects: 100% (1797/1797), 485.23 KiB | 0 bytes/s, done.
>Resolving deltas: 100% (1545/1545), completed with 327 local objects.
>Checking connectivity... done.
>Checking out files: 100% (44979/44979), done.
>
>  Luis



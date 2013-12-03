Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3LCHQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:16:13 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752559Ab3LCHQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:16:10 -0500
From: Richard Weinberger <richard@nod.at>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with Linus' tree
Date: Tue, 03 Dec 2013 08:16:04 +0100
Message-ID: <1552053.4Szip5nVtU@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131203125219.97839b4335adffdeb3ef7160@canb.auug.org.au>
References: <20131203125219.97839b4335adffdeb3ef7160@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Am Dienstag, 3. Dezember 2013, 12:52:19 schrieb Stephen Rothwell:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> arch/um/kernel/sysrq.c between commit 8ed12fcc194d ("um: Rename
> print_stack_trace to do_stack_trace") from Linus' tree and commit
> ce89e7878311 ("arch/um/kernel/sysrq.c: rename print_stack_trace()") from
> the akpm-current tree.
> 
> I fixed it up (I used the version fro, Linus' tree) and can carry the fix
> as necessary (no action is required).

How comes that this patch landed in your tree, I didn't receive a mail from 
your bot?
Anyway, it found it's way into Linus' tree using my UML tree.

Thanks,
//richard

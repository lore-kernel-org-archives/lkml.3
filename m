Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3BRGeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:34:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57920 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab3BRGd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:33:59 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130218143528.451b9e1e19d79693c5673414@canb.auug.org.au>
References: <20130218143528.451b9e1e19d79693c5673414@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: manual merge of the tip tree with the kbuild tree
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 17 Feb 2013 22:31:38 -0800
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Message-ID: <d79f6bb4-0ddc-4958-a3d3-15062928e436@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is the right fix indeed.

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>Hi all,
>
>Today's linux-next merge of the tip tree got a conflict in
>kernel/timeconst.pl between commit 70730bca1331 ("kernel: Replace
>timeconst.pl with a bc script") from the kbuild tree and commit
>63a3f603413f ("timeconst.pl: Eliminate Perl warning") from the tip
>tree.
>
>I just droppped the tip tree version (I deleted the file) and can carry
>the fix as necessary (no action is required).

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

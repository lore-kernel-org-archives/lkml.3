Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaFPPtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:49:21 -0400
Received: from r00tworld.com ([212.85.137.150]:35810 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbaFPPtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:49:20 -0400
X-Greylist: delayed 1159 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 11:49:19 EDT
From: "PaX Team" <pageexec@freemail.hu>
To: "=?UTF-8?Q?Jan-Simon_M=C3=B6ller?=" <dl9pf@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Date: Mon, 16 Jun 2014 17:29:25 +0200
MIME-Version: 1.0
Subject: Re: 3d3d6b847420 ("kbuild: LLVMLinux: Adapt warnings for compilation with clang")
Reply-to: pageexec@freemail.hu
CC: Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <mcharleb@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Message-ID: <539F0D55.31207.1DF87EFF@pageexec.freemail.hu>
In-reply-to: <20140616130751.GD8170@pd.tnic>
References: <20140616130751.GD8170@pd.tnic>
X-mailer: Pegasus Mail for Windows (4.70)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 16 Jun 2014 17:29:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jun 2014 at 15:07, Borislav Petkov wrote:

> Please fix this to have effect only for clang but not for the rest of
> the universe.

i'd suggest reverting it instead, there're probably some stale entries
in there already (e.g., -fcatch-undefined-behavior).


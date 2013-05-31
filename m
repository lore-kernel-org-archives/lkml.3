Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3EaJPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:15:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36440 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab3EaJP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:15:28 -0400
Date: Fri, 31 May 2013 11:15:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 00/16] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130531091540.GH14076@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:47:20AM +0200, Robert Richter wrote:
> Patches base on Boris' patches which I have rebased to latest
> tip/perf/core. All patches can be found here:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git persistent

Right, we should merge the fixes/changes to the persistent patches with
the original ones since they are still WIP anyway.

Feel free to rework them as you see fit, or, I could do that when I get
back.

Thanks.

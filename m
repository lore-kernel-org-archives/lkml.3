Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaKRB4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:56:17 -0500
Received: from one.firstfloor.org ([193.170.194.197]:49310 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaKRB4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:56:16 -0500
Date: Tue, 18 Nov 2014 02:56:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141118015614.GE12538@two.firstfloor.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <20141117213457.GE4163@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117213457.GE4163@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 06:34:57PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Nov 12, 2014 at 06:05:18PM -0800, Andi Kleen escreveu:
> > [Reworks to address all the review feedback. Rebased to latest tree]
> > [Just a repost after a rebase]
> > [Even more review feedback and some bugs addressed.]
> > [Only port to changes in perf/core. No other changes.]
> > [Rebase to latest perf/core]
> > [Another rebase. No changes]
> > 
> > This patchkit implements lbr-as-callgraphs in per freport,
> > as an alternative way to present LBR information.
> 
> Ok, I have this in my perf/core branch, but I need to test it further,
> as I couldn't get the output that appears on some of the changelogs.
> 
> If you could take a look at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> To see if I made some mistake, that would be of help,

Sorry the CCKEY_ADDRESS hunk was actually needed. With that I get
the srclines as expected.

Also the BUILD_BUG_ON change breaks the compilation with optimization
off (DEBUG=1). I'll send patches for both.

Also please consider the adding the symbol offset fix patch
I sent Friday.

-Andi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936246AbaH1D20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:28:26 -0400
Received: from p01c12o142.mxlogic.net ([208.65.145.65]:38714 "EHLO
	p01c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbaH1D2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:28:25 -0400
X-MXL-Hash: 53fea1d97a9df7ff-35686d18b8ce9f8d2e655f360ad8210c2f9fd686
X-MXL-Hash: 53fea1d3003f968b-f8460598c9ad2d1433d32a0cdd94004156a8a259
Date: Wed, 27 Aug 2014 23:28:05 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Allow commit descriptions on separate line
 from commit id
In-Reply-To: <1409189901.25751.16.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1408272319440.5674@jlaw-desktop.mno.stratus.com>
References: 1404338448.14741.8.camel@joe-AO725 <20140827131135.6d789d26@jlaw-desktop.mno.stratus.com> <1409189901.25751.16.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=YPyLyH2x c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=nXGuE6rTyBAA:10 a=7Uz]
X-AnalysisOut: [NioCSru0A:10 a=ZKic5cfpby4A:10 a=_KQqW7t0BisA:10 a=CdzKgOd]
X-AnalysisOut: [8jloA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=uelBKuKpAAA]
X-AnalysisOut: [A:8 a=YlVTAMxIAAAA:8 a=IJv9LcIfAAAA:8 a=UqJL74uTslyS59wjxn]
X-AnalysisOut: [QA:9 a=CjuIK1q_8ugA:10 a=K6kUPx8HyhEA:10 a=kSViFEBMy1sA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014082710); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 Aug 2014, Joe Perches wrote:

> The general form for commit id and description is
> 
> 'Commit <12+hexdigits> ("commit description/subject line")'
> 
> But commit logs often have relatively long commit ids and
> the commit description is on a separate line like:
> 
> Some explanation as to why commit <12+hexdigits>
> ("commit description/subject line") is improved.
> 
> Allow this form.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Suggested-by: Joe Lawrence <joe.lawrence@stratus.com

Hi Joe,

The script changes work for me, one really minor nit though, this email 
address is missing a closing '>'.  (Maybe another checkpatch validation 
for another day?)

Thanks,

-- Joe

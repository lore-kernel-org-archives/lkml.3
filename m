Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3H0MsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:48:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47378 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab3H0MsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:48:05 -0400
Date: Tue, 27 Aug 2013 14:48:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130827124812.GC5855@x1.alien8.de>
References: <20130823091128.GA19548@nazgul.tnic>
 <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost>
 <20130823113400.GA20310@nazgul.tnic>
 <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy>
 <20130823193934.GB15521@pd.tnic>
 <alpine.DEB.2.10.1308231704450.24113@vincent-weaver-1.um.maine.edu>
 <20130827115422.GD15884@rric.localhost>
 <20130827122242.GA5855@x1.alien8.de>
 <20130827124146.GG15884@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130827124146.GG15884@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:41:46PM +0200, Robert Richter wrote:
> We still have multiple users after 'claiming' the event. The only
> thing is that the event will be destroyed after all users went away. A
> process (that claimed the event) was responsible for this.

Ok, if the "claimer" process which owns the event dies for some reason,
then I'm guessing some other event can claim it on its own, i.e.
processes can claim events among each other...

> I still prefer claim/unclaim. ;)

Oh well, whatever, as long as it not misleading :-)

-- 
Regards/Gruss,
Boris.

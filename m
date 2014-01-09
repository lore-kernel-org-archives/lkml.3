Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaAIMhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:37:18 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47528 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaAIMhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:37:10 -0500
Subject: Re: [patch] perf tools: perf list broken on ARM
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20140109121206.GA30069@ghostprotocols.net>
References: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu>
	 <alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu>
	 <871u0hd0x4.fsf@sejong.aot.lge.com>
	 <20140109121206.GA30069@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jan 2014 21:37:03 +0900
Message-ID: <1389271023.1722.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-09 (목), 09:12 -0300, Arnaldo Carvalho de Melo:
> Em Thu, Jan 09, 2014 at 05:17:27PM +0900, Namhyung Kim escreveu:
> > Hi Vince,
> > 
> > On Wed, 8 Jan 2014 16:30:17 -0500 (EST), Vince Weaver wrote:
> > > just checking on the status of this patch.  Am I sending it to the wrong 
> > > place?  Did it get lost in the post-holiday e-mail purges?  
> > >
> > > The bug is annoying if you're trying to use perf on ARM systems.
> > 
> > Right, acme, would you please merge this?
> 
> I will, but having a patch authored by someone and Acked-by that same
> person looks weird, so, to clarify, this was written by Vince, acked by
> you, right?

You seemed to be confused - it's not authored by me.  He was just
referring a problematic commit b41f1cec91c3 which was written by me.  So
yeah, this commit was written by Vince.

Thanks,
Namhyung



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbaBEUdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:33:12 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:39564 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbaBEUdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:33:07 -0500
Date: Wed, 5 Feb 2014 15:34:42 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch] perf tools: perf list broken on ARM
In-Reply-To: <20140109124845.GB30069@ghostprotocols.net>
Message-ID: <alpine.DEB.2.10.1402051532250.14738@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1312301536150.28814@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1401081629200.4410@vincent-weaver-1.um.maine.edu> <871u0hd0x4.fsf@sejong.aot.lge.com> <20140109121206.GA30069@ghostprotocols.net> <1389271023.1722.4.camel@leonhard>
 <20140109124845.GB30069@ghostprotocols.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-710285643-1391632487=:14738"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-710285643-1391632487=:14738
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 9 Jan 2014, Arnaldo Carvalho de Melo wrote:

> Em Thu, Jan 09, 2014 at 09:37:03PM +0900, Namhyung Kim escreveu:
> > 2014-01-09 (목), 09:12 -0300, Arnaldo Carvalho de Melo:
> > > Em Thu, Jan 09, 2014 at 05:17:27PM +0900, Namhyung Kim escreveu:
> > > > Hi Vince,
> > > > 
> > > > On Wed, 8 Jan 2014 16:30:17 -0500 (EST), Vince Weaver wrote:
> > > > > just checking on the status of this patch.  Am I sending it to the wrong 
> > > > > place?  Did it get lost in the post-holiday e-mail purges?  
> > > > >
> > > > > The bug is annoying if you're trying to use perf on ARM systems.
> > > > 
> > > > Right, acme, would you please merge this?
> > > 
> > > I will, but having a patch authored by someone and Acked-by that same
> > > person looks weird, so, to clarify, this was written by Vince, acked by
> > > you, right?
> > 
> > You seemed to be confused - it's not authored by me.  He was just
> > referring a problematic commit b41f1cec91c3 which was written by me.  So
> > yeah, this commit was written by Vince.
> 
> You are right, I saw that Author: line in the changeset comment, close
> to the start of the message and got confused, thanks for clarifying.

Do I need to re-send this patch?  It still applies cleanly to 3.14-rc1.

Vince
--8323329-710285643-1391632487=:14738--

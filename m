Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab3DMB13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:27:29 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:48056 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3DMB12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:27:28 -0400
Date: Fri, 12 Apr 2013 22:27:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
Message-ID: <20130413012721.GA12924@ghostprotocols.net>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
 <1365681898-19897-5-git-send-email-namhyung@kernel.org>
 <1365691175.9609.33.camel@gandalf.local.home>
 <1365691255.9609.34.camel@gandalf.local.home>
 <1365815846.1769.11.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365815846.1769.11.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Apr 13, 2013 at 10:17:26AM +0900, Namhyung Kim escreveu:
> > I just want to know more about this patch before I ack it.
> 
> The page size of traced system can be different than current system's
> because the recorded data file might be analyzed in a different machine.
> In this case we should use original page size of traced system when
> accessing the data file, so this information needs to be saved.

Excellent explanation! So good it deserves being in the changelog
commit!

8-)

- Arnaldo

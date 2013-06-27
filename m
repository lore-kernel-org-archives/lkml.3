Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3F0JVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:21:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3F0JVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:21:36 -0400
Date: Thu, 27 Jun 2013 11:21:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf tools: Introduce new -P/--parent-deep report option
Message-ID: <20130627092129.GB3225@krava.brq.redhat.com>
References: <20130626145853.GA2309@ghostprotocols.net>
 <87a9mc15qm.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9mc15qm.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 02:29:21PM +0900, Namhyung Kim wrote:
> Hi Arnaldo,
> 
> On Wed, 26 Jun 2013 11:58:53 -0300, Arnaldo Carvalho de Melo wrote:
> > Hi Jiri,
> >
> > 	About the patch below, can't this be solved by using a regex
> > instead of a simple substring search instead of adding a new command
> > line option?
> 
> ???
> 
> IIUC he reused parent_regex for this.
> 
> And I think we can have the same effect by using -G and -p option
> together without this new option.

I think you're right.. I haven't realized I could reverse
the backtrace and search the same way via -p

thanks,
jirka

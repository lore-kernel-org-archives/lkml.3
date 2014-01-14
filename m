Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaANNPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:15:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANNPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:15:50 -0500
Date: Tue, 14 Jan 2014 14:15:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf probe: Build error with missing libraries
Message-ID: <20140114131540.GB5520@krava.brq.redhat.com>
References: <20140113180400.GD5318@ghostprotocols.net>
 <20140113181458.GE5318@ghostprotocols.net>
 <52D495D1.5080505@hitachi.com>
 <20140114130907.GA29798@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114130907.GA29798@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 10:09:07AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 14, 2014 at 10:41:37AM +0900, Masami Hiramatsu escreveu:
> > (2014/01/14 3:14), Arnaldo Carvalho de Melo wrote:
> > > Jiri, this is something else for the give-me-more-ponies list for
> > > tests/make: build it on freshly provisioned systems with multiple mixes
> > > of devel packages installed ;-)
>  
> > I think we can change makefile to get some combinations of config options
> > when building perf tools.
> 
> This is what:
> 
>  make -C tools/perf -f tests/make
> 
> does, and we use it already, many config combos are tested, but that
> kinda expects that all optional devel libs be installed.
> 
> What I'm talking about is to, in addition, install the devel packages
> iteratively, testing those config options combos with and without
> installed devel packages combos.

yep, sounds good.. maybe another script setting the environment
(randomly, with some logic never to repeat any config?) and running
tests/make suite

jirka

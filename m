Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3LSQG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:06:26 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61016 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3LSPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:51:25 -0500
Date: Thu, 19 Dec 2013 16:51:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/6] perf tools: A couple of TUI improvements
Message-ID: <20131219155122.GA27508@gmail.com>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
 <20131219133915.GE3568@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219133915.GE3568@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, Dec 19, 2013 at 04:00:05PM +0900, Namhyung Kim wrote:
> > Hello,
> > 
> > I was playing with TUI code and added two new windows.  One for
> > showing log messages and another for showing header information.
> > (Maybe they can be implemented on the GTK code too someday.)
> > 
> > Please try to use it! :)
> 
> hi,
> I'm sure the 'i' header display will be appreciated!
> 
> Any chance of searching capability in the 'l' log window?
> mutt-like limit('l') command would be great ;-)

+1 :-)

	Ingo

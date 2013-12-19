Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3LSNjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:39:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3LSNje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:39:34 -0500
Date: Thu, 19 Dec 2013 14:39:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/6] perf tools: A couple of TUI improvements
Message-ID: <20131219133915.GE3568@krava.brq.redhat.com>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:00:05PM +0900, Namhyung Kim wrote:
> Hello,
> 
> I was playing with TUI code and added two new windows.  One for
> showing log messages and another for showing header information.
> (Maybe they can be implemented on the GTK code too someday.)
> 
> Please try to use it! :)

hi,
I'm sure the 'i' header display will be appreciated!

Any chance of searching capability in the 'l' log window?
mutt-like limit('l') command would be great ;-)

thanks,
jirka

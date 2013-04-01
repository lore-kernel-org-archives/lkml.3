Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab3DATtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:49:09 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:44215 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465Ab3DATtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:49:07 -0400
Date: Mon, 1 Apr 2013 21:49:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/27] perf tools: Fix tab vs spaces issue in Makefile
	ifdef/endif
Message-ID: <20130401194905.GA5744@merkur.ravnborg.org>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com> <1364843930-17974-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364843930-17974-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 09:18:25PM +0200, Jiri Olsa wrote:
> Unmatched spaces/tabs Makefile indentation could make the
> Makefile fails. While the tabed line could be considered
> sometimes as follow up for rule command, the mixed space
> tab meses up with makefile if conditions.

I have too many times been beaten that asssignments was
ignored because I used tabs to indendt the assignmnet.
So in all Makefile I edit spaces are used for indent.
Tabs are only used for commands.

	Sam

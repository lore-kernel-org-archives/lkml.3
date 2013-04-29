Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3D2KDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:03:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab3D2KC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:02:59 -0400
Date: Mon, 29 Apr 2013 12:02:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 21/26] perf tools: Switch to full patch C include
 directories
Message-ID: <20130429100202.GC1106@krava.brq.redhat.com>
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
 <1366796273-4780-22-git-send-email-jolsa@redhat.com>
 <517AAACD.10508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517AAACD.10508@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:26:53AM -0600, David Ahern wrote:
> On 4/24/13 3:37 AM, Jiri Olsa wrote:
> >Switching to full patch C include directories, to make
> >the includes clear.
> 
> s/patch/path/ ?  email subject line too
> 

ok, thanks

jirka

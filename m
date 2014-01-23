Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaAWOYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:24:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbaAWOYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:24:43 -0500
Date: Thu, 23 Jan 2014 15:24:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 5/5] perf tools: Show absolute percentage by default
Message-ID: <20140123142414.GC1180@krava.brq.redhat.com>
References: <1390433333-15350-1-git-send-email-namhyung@kernel.org>
 <1390433333-15350-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390433333-15350-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:28:53AM +0900, Namhyung Kim wrote:
> Now perf report will show absolute percentage on filter entries by
> default.
> 
> Suggested-by: Jiri Olsa <jolsa@redhat.com>

Acked-by: Jiri Olsa <jolsa@redhat.com> ;-)

once the 1st patch issues are solved, I'm ok with this

thanks,
jirka

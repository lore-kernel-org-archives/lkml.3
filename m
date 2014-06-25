Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaFYHdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:33:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbaFYHdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:33:31 -0400
Date: Wed, 25 Jun 2014 09:33:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Howard Cochran <hcochran@lexmark.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: event-parse.c:  Fix a risk for
 doing free on uninitialized pointer
Message-ID: <20140625073318.GB1153@krava.brq.redhat.com>
References: <1403608150-13037-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <87oaxh6bps.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oaxh6bps.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:04:47AM +0900, Namhyung Kim wrote:
> Hi Rickard,
> 
> On Tue, 24 Jun 2014 13:09:10 +0200, Rickard Strandqvist wrote:
> > Fix a risk of doing free on an uninitialized pointer.
> >
> > This was found using a static code analysis program called cppcheck.
> >
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

thanks, queued

jirka

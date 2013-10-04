Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3JDPZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:25:34 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:37077 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3JDPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:25:32 -0400
Date: Fri, 4 Oct 2013 12:25:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] perf session: Fix infinite loop on invalid perf.data file
Message-ID: <20131004152524.GA2265@ghostprotocols.net>
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
 <20131001071646.GA20023@gmail.com>
 <524ACD2A.7040902@gmail.com>
 <20131001142154.GA31298@gmail.com>
 <524ADF84.4080801@gmail.com>
 <20131001153309.GA1287@gmail.com>
 <20131001165437.GF2920@ghostprotocols.net>
 <524AFF5A.3030909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524AFF5A.3030909@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 01, 2013 at 10:59:06AM -0600, David Ahern escreveu:
> On 10/1/13 10:54 AM, Arnaldo Carvalho de Melo wrote:
> >Em Tue, Oct 01, 2013 at 05:33:09PM +0200, Ingo Molnar escreveu:
> >>* David Ahern <dsahern@gmail.com> wrote:
> >>>On 10/1/13 8:21 AM, Ingo Molnar wrote:
> >I liked this last one:
> >
> >>   WARNING: The perf.data file's data size field is 0 which is unexpected.
> >>            Was the 'perf record' command properly terminated?
> >
> >Can I patch that up into Namhyung's latest patch?
> >
> >Sonny, David, from your replies I think I can add Tested-by: tags for
> >both of you?
> 
> I'm fine with the last message. And yes a Tested by

Got to process this now, changing it a bit to replace "perf.data" with
"%s" + session->filename, ack?

Otherwise the user may have a 'perf.data' file and despite having
informed -i with a different file name still get confused... ;-)

- Arnaldo

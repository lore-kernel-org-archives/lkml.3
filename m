Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966332AbaFSXiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:38:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48247 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965603AbaFSXh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:37:59 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] perf tools: Add report.show-headers config file option
References: <1403178076-14072-1-git-send-email-jolsa@kernel.org>
	<1403178076-14072-6-git-send-email-jolsa@kernel.org>
	<1403182604.1670.26.camel@leonhard>
	<20140619130202.GA24328@krava.brq.redhat.com>
	<1403183399.1670.30.camel@leonhard>
	<20140619165113.GB31520@krava.brq.redhat.com>
Date: Fri, 20 Jun 2014 08:37:57 +0900
In-Reply-To: <20140619165113.GB31520@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 19 Jun 2014 18:51:13 +0200")
Message-ID: <87r42k79nu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 18:51:13 +0200, Jiri Olsa wrote:
> On Thu, Jun 19, 2014 at 10:09:59PM +0900, Namhyung Kim wrote:
>> 2014-06-19 (목), 15:02 +0200, Jiri Olsa:
>> > On Thu, Jun 19, 2014 at 09:56:44PM +0900, Namhyung Kim wrote:
>> > > [SNIP]
>> > > > @@ -35,6 +35,7 @@ struct symbol_conf symbol_conf = {
>> > > >  	.demangle		= true,
>> > > >  	.cumulate_callchain	= true,
>> > > >  	.symfs			= "",
>> > > > +	.show_headers		= -1,
>> > > 
>> > > Hmm.. why not just making it boolean and set it to true (like others)?
>> > 
>> > I need 'unset' value, otherwise I dont know if the config
>> > option was unset by user or not touched at all
>> 
>> I don't understand why you need it..  isn't it enough to check the
>> config option before using the value?
>
> if config file option is not specified the show_headers
> value will be 'false' ... 

Confused.  What makes it to be false if its default value is true and
the config option is not specified?

Thanks,
Namhyung


> which will cause headers not
> to be displayed.. but they should be by default
>
> jirka

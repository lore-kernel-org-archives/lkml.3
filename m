Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaAPB0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:26:20 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52191 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaAPB0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:26:17 -0500
X-AuditID: 9c930197-b7b7cae000000e34-ad-52d735374cde
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf probe: Build error with missing libraries
References: <20140113180400.GD5318@ghostprotocols.net>
	<20140113181458.GE5318@ghostprotocols.net>
	<52D495D1.5080505@hitachi.com>
	<20140114130907.GA29798@ghostprotocols.net>
	<87sisq9fa5.fsf@sejong.aot.lge.com>
	<20140115183856.GD9750@ghostprotocols.net>
Date: Thu, 16 Jan 2014 10:26:15 +0900
In-Reply-To: <20140115183856.GD9750@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 15 Jan 2014 15:38:56 -0300")
Message-ID: <874n5490p4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 15:38:56 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 15, 2014 at 10:58:58AM +0900, Namhyung Kim escreveu:
>> Hi Arnaldo,
>> 
>> On Tue, 14 Jan 2014 10:09:07 -0300, Arnaldo Carvalho de Melo wrote:
>> > Em Tue, Jan 14, 2014 at 10:41:37AM +0900, Masami Hiramatsu escreveu:
>> >> (2014/01/14 3:14), Arnaldo Carvalho de Melo wrote:
>> >> > Jiri, this is something else for the give-me-more-ponies list for
>> >> > tests/make: build it on freshly provisioned systems with multiple mixes
>> >> > of devel packages installed ;-)
>> >  
>> >> I think we can change makefile to get some combinations of config options
>> >> when building perf tools.
>> >
>> > This is what:
>> >
>> >  make -C tools/perf -f tests/make
>> >
>> > does, and we use it already, many config combos are tested, but that
>> > kinda expects that all optional devel libs be installed.
>> 
>> I've been thinking that the above should look like below.
>> 
>>   make build-test (-C tools/perf)
>> 
>> 
>> Maybe something like this?
>
> Haven't tested, but I think it is worth to make this a shortcut, care to
> test (if not yet) and resubmit with proper S-O-B, etc?

OK, will do!

Thanks,
Namhyung

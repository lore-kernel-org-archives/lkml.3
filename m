Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218Ab3CMT7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:59:06 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:49250 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab3CMT7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:59:03 -0400
Message-ID: <5140DA7A.1030405@gmail.com>
Date: Wed, 13 Mar 2013 13:58:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf fails to compile for latest Linus tree
References: <5140923B.4040102@gmail.com> <20130313195656.GG11779@ghostprotocols.net>
In-Reply-To: <20130313195656.GG11779@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/13 1:56 PM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Mar 13, 2013 at 08:50:35AM -0600, David Ahern escreveu:
>> I believe this has been fixed but I don't see it in your tree
>> (perf/core or perf/urgent) or in the tip tree:
>
>> builtin-annotate.c: In function ‘hists__find_annotations’:
>> builtin-annotate.c:161:4: error: duplicate case value
>> builtin-annotate.c:154:4: error: previously used here
>> make: *** [/tmp/pbuild/builtin-annotate.o] Error 1
>> make: *** Waiting for unfinished jobs....
>
> Yeah, this is because you don't have newt-devel installed, please try
> with acme/perf/urgent after two patches from Michael Ellerman appear at
> its head, I just pushed it.

right. minimal F18 install. I don't have python-config installed either 
which makes perf unhappy. Have to add PYTHON_CONFIG=/bin/false to get it 
to work. Can't figure out the logic to have it test for the executable.

David


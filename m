Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3KANat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:30:49 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62573 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3KANas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:30:48 -0400
Message-ID: <5273AD00.1050002@gmail.com>
Date: Fri, 01 Nov 2013 07:30:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf version not set when building out of tree
References: <5272E86B.7090003@gmail.com> <20131101070219.GA21471@gmail.com>
In-Reply-To: <20131101070219.GA21471@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/13, 1:02 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> When building out of tree:
>>
>> make perf-tar-src-pkg
>
> What's the canonical way to build a perf tarball? I didn't find any
> makefile target for that.

Perhaps I misunderstand your question. From the top-level of a kernel tree:
$ make help | grep perf

   perf-tar-src-pkg    - Build perf-3.12.0-rc5.tar source tarball
   perf-targz-src-pkg  - Build perf-3.12.0-rc5.tar.gz source tarball
   perf-tarbz2-src-pkg - Build perf-3.12.0-rc5.tar.bz2 source tarball
   perf-tarxz-src-pkg  - Build perf-3.12.0-rc5.tar.xz source tarball

David

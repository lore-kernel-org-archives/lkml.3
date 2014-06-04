Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaFDB74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:59:56 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34869 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaFDB7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:59:54 -0400
Message-ID: <538E7D96.5070401@gmail.com>
Date: Tue, 03 Jun 2014 19:59:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org
CC: jolsa@redhat.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 00/32] perf and kconfig kbuild (2nd try)
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com> <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/14, 4:05 PM, Alexis Berlemont wrote:
> Alexis Berlemont (29):
>    kbuild: add support of custom paths for "auto.conf*" files
>    perf kbuild: fix recursive invocation of config/features-checks
>    perf kbuild: store in config-detected missing variables (libdir, ...)
>    perf kbuild: remove useless #ifdef directives
>    perf kbuild: fix a link issue if BUILTIN_TRACE is disabled
>    perf kbuild: add missing files and missing flags in Kbuild files
>    perf kbuild: update kbuild files according to last changes
>    perf kbuild: remove legacy slang-related build variables
>    perf kbuild: remove legacy libaudit-related build variables
>    perf kbuild: remove legacy libgtk2-related build variables
>    perf kbuild: remove legacy libperl-related build variables
>    perf kbuild: remove legacy timerfd-related build variable
>    perf kbuild: remove legacy demangle-related build variables
>    perf kbuild: remove legacy on_exit-related build variable
>    perf kbuild: remove legacy backtrace-related build variable
>    perf kbuild: remove legacy numa-related build variable
>    perf kbuild: remove legacy bionic-related build variable
>    perf kbuild: remove legacy libelf-related build variables (1st part)
>    perf kbuild: remove legacy libelf-related build variables (2nd part)
>    perf kbuild: remove legacy libdwarf-related build variables
>    perf kbuild: remove legacy libpython-related build variable
>    perf kbuild: add generated Kconfig build-test cases
>    perf kbuild: fix installation of traceevent plugins
>    perf kbuild: fix tarpkg target in tests/make
>    perf kbuild: update Kbuild files with new and removed sources
>    perf kbuild: update build test configurations
>    perf kbuild: relocate the configs generating script
>    perf kbuild: minor changes
>    perf kbuild: remove Makefile.perf


In general you are missing commit messages that explain why the patch is 
needed -- what does it do, what is changed. The code should evolve from 
where it is to where you want it to be in small focused patches that do 
not break compiles or features (important for git-bisect).

For patches that you are leveraging from Jiri odds are they need to be 
updated for what has happened over the past year since Jiri's last 
effort on this. I suggest doing the updates in line with Jiri's patch 
and add a comment of what was added to Jiri's patch.

Also add Namhyung Kim <namhyung@kernel.org> to your CC list.

Thanks,
David

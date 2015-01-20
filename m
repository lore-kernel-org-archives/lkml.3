Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbbATXDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:03:00 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46922 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbbATXC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:02:57 -0500
Message-ID: <54BEDE9B.2000900@gmail.com>
Date: Tue, 20 Jan 2015 16:02:51 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jan Heylen <heyleke@gmail.com>,
        Mark Salter <msalter@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv3 00/36] perf tools: New build framework
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/15 9:38 AM, Jiri Olsa wrote:
> The patchset is also available in:
>    git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>    perf/build

Do I have to guess which branch?

$ git branch -a | grep jirka | grep build
   remotes/jirka/perf/build
   remotes/jirka/perf/build_1
   remotes/jirka/perf/build_3
   remotes/jirka/perf/build_4
   remotes/jirka/perf/build_6
   remotes/jirka/perf/buildid_3
   remotes/jirka/perf/buildid_4
   remotes/jirka/perf/core_buildid_cache_clean
   remotes/jirka/perf/kbuild1
   remotes/jirka/perf/kbuild2
   remotes/jirka/perf/kbuild3
   remotes/jirka/perf/kbuild4
   remotes/jirka/perf/kbuild7
   remotes/jirka/perf/kbuild9

David

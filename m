Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbbAUXbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:31:03 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44980 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbbAUXbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:31:00 -0500
Date: Wed, 21 Jan 2015 15:30:44 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
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
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv3 00/36] perf tools: New build framework
Message-ID: <20150121233043.GA23660@us.ibm.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012123-8236-0000-0000-000008D1C03C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@kernel.org] wrote:
| 
| The patchset is also available in:
|   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
|   perf/build
| 
| All tests/make tests passed.
| 

The build and make tests passed on my Power8 system.

Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>


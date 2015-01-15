Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbbAOQWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:22:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbbAOQWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:22:16 -0500
Date: Thu, 15 Jan 2015 17:21:09 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/36] tools build: Add detected config support
Message-ID: <20150115162109.GC17228@krava.brq.redhat.com>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
 <1421326532-25660-3-git-send-email-jolsa@kernel.org>
 <54B7E1D0.1050805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B7E1D0.1050805@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 08:50:40AM -0700, David Ahern wrote:
> On 1/15/15 5:54 AM, Jiri Olsa wrote:
> >Adding support to include detected configuration makefile
> >into the build process. This will allow the Build objects
> >to be configurable based on the config data, like:
> >
> >   perf-$(CONFIG_KRAVA) += krava.o
> >
> >The configuration is stored in '.config-detected' file,
> >which is generated for each compilation.
> 
> So this file is similar to kernel's .config file and is generated based on
> today's autoprobing?
> 

yep, it's the way to pass detected data/variables from perf detection
system (config/Makefile) to the build framework, it get's generated
every build

the plan is to have '.config' in the future that will gather user's
configuration

jirka

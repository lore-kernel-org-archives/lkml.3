Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbbAVLdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:33:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbbAVLdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:33:35 -0500
Date: Thu, 22 Jan 2015 12:32:47 +0100
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
Subject: Re: [PATCH 20/36] perf build: Add arch x86 objects building
Message-ID: <20150122113247.GA1625@krava.brq.redhat.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
 <1421771973-6022-21-git-send-email-jolsa@kernel.org>
 <54C0177C.3060703@gmail.com>
 <20150121213157.GH6835@krava.brq.redhat.com>
 <54C01E14.8020906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C01E14.8020906@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 02:45:56PM -0700, David Ahern wrote:
> On 1/21/15 2:31 PM, Jiri Olsa wrote:
> >the thing is that in arch/Build we now do:
> >
> >+libperf-y += $(ARCH)/
> >
> >which would make the build to fail on other architectures,
> >because the build framework requires 'Build' file in
> >nested directories.. and this patch adds it only for x86
> 
> ok. perhaps add that to the commit message.

right, will do

thanks,
jirka

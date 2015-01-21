Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbbAUTXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:23:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbbAUTXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:23:30 -0500
Date: Wed, 21 Jan 2015 20:22:42 +0100
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
Subject: Re: [PATCH 08/36] perf build: Add builtin objects building
Message-ID: <20150121192242.GG6835@krava.brq.redhat.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
 <1421771973-6022-9-git-send-email-jolsa@kernel.org>
 <54BFF557.1070809@gmail.com>
 <20150121191223.GF6835@krava.brq.redhat.com>
 <54BFFBA1.8060403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BFFBA1.8060403@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:18:57PM -0700, David Ahern wrote:
> On 1/21/15 12:12 PM, Jiri Olsa wrote:
> >hum I can't reproduce, but I can see why
> 
> I'm using a 16-cpu box, so perf build defaults to 16 jobs. Perhaps you are
> getting lucky with the build ordering?
> 

yea probably.. I tested commit by commit builds on 4cpu server only
and used big servers only for overall 'tests/make' run

jirka

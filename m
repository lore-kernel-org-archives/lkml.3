Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077AbaILQyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:54:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaILQyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:54:13 -0400
Date: Fri, 12 Sep 2014 18:54:07 +0200
From: Borislav Petkov <bp@suse.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 11/14] tools lib api: Adopt fdarray class from perf's
 evlist
Message-ID: <20140912165406.GA7139@nazgul.tnic>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-12-git-send-email-acme@kernel.org>
 <20140912125822.GA23205@krava.brq.redhat.com>
 <20140912134429.GF1801@kernel.org>
 <20140912141631.GA22187@krava.brq.redhat.com>
 <20140912142225.GI1801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140912142225.GI1801@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:22:25AM -0300, Arnaldo Carvalho de Melo wrote:
> Yeah, to me as well, but then zfree() was such a nice pick and looked ok
> at the time :-)
> 
> I'm leaving this for later, different patchkit that would sweep thru
> tools/ and find this pattern, make it use freez() (or some other name),
> etc.

freez() sounds like something gets frozen :-P and not freed.

-- 
Regards/Gruss,
    Boris.
--

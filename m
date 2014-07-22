Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaGVHwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:52:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbaGVHwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:52:42 -0400
Date: Tue, 22 Jul 2014 09:51:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Fix incorrect fd error comparison
Message-ID: <20140722075158.GA29305@krava.redhat.com>
References: <20140716142031.GD9441@krava.redhat.com>
 <1405586590-13657-1-git-send-email-adrian.hunter@intel.com>
 <1405586590-13657-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405586590-13657-2-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:43:09AM +0300, Adrian Hunter wrote:
> Zero is a valid fd.  Error comparison should check
> for negative fd.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

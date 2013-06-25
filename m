Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3FYN7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:59:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3FYN7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:59:21 -0400
Date: Tue, 25 Jun 2013 15:58:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/15] perf tools: fix missing 'finished_round'
Message-ID: <20130625135847.GF23329@krava.brq.redhat.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
 <1372079772-20803-4-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372079772-20803-4-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 04:16:00PM +0300, Adrian Hunter wrote:
> By default, perf inject should "repipe" all events
> including 'finished_round'.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

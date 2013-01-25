Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3AYCxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:53:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3AYCxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:53:08 -0500
Date: Thu, 24 Jan 2013 23:52:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 2/2] perf stat: add interval printing
Message-ID: <20130125025247.GA16249@infradead.org>
References: <1358860732-4435-1-git-send-email-eranian@google.com>
 <1358860732-4435-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358860732-4435-3-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 22, 2013 at 02:18:52PM +0100, Stephane Eranian escreveu:
> This patch adds a new printing mode for perf stat.
> It allows internval printing. That means perf stat
> can now print event deltas at regular time interval.
> This is useful to detect phases in programs.

This patch is not applying to my perf/core branch, does it depend on
some other outstanding patchset from you?

Tomorrow probably all I had in this area will be in Ingo's tree, but
can you please take a look at my perf/core branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux

?

Regards,

- Arnaldo

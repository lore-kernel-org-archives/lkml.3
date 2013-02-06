Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab3BFTvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:51:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758379Ab3BFTvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:45 -0500
Date: Wed, 6 Feb 2013 16:51:32 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 2/2] perf stat: add per processor socket count aggregation
Message-ID: <20130206195131.GD29163@infradead.org>
References: <1360161962-9675-1-git-send-email-eranian@google.com>
 <1360161962-9675-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360161962-9675-3-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 06, 2013 at 03:46:02PM +0100, Stephane Eranian escreveu:
>  tools/perf/builtin-stat.c |  126 +++++++++++++++++++++++++++++++++++++++++----

Added the missing 'perf stat' man page entry based on the changeset
comments,

- Arnaldo

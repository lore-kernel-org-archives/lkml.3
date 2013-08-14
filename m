Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab3HNOWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:22:13 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:63078 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab3HNOWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:22:12 -0400
Date: Wed, 14 Aug 2013 11:22:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tests: Fix compile failure on do_sort_something - v2
Message-ID: <20130814142205.GB2138@ghostprotocols.net>
References: <1376454732-83728-1-git-send-email-dsahern@gmail.com>
 <520B6490.9000001@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520B6490.9000001@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 14, 2013 at 02:05:52PM +0300, Adrian Hunter escreveu:
> On 14/08/13 07:32, David Ahern wrote:
> > Commit b55ae0a9 added code-reading.c which fails to compile on Fedora 16
> > with compiler version:
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> 
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Applied

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3JJHMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:12:24 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55358 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3JJHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:12:23 -0400
Date: Thu, 10 Oct 2013 09:12:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 03/52] tools/perf/build: Add 'autodep' functionality,
 generate feature test dependencies automatically
Message-ID: <20131010071220.GK10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-4-git-send-email-mingo@kernel.org>
 <87li21k7d6.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li21k7d6.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue,  8 Oct 2013 12:10:33 +0200, Ingo Molnar wrote:
> > +-include *.d */*.d
> 
> Hmm.. this */*.d part is really needed?

Indeed! :-) I'll remove it.

Thanks,

	Ingo

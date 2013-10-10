Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3JJGuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:50:46 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:52944 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3JJGun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:50:43 -0400
Date: Thu, 10 Oct 2013 08:50:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 26/52] tools/perf/build: Split out feature check: 'libbfd'
Message-ID: <20131010065040.GD10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-27-git-send-email-mingo@kernel.org>
 <871u3tk6ag.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u3tk6ag.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue,  8 Oct 2013 12:10:56 +0200, Ingo Molnar wrote:
> > +test-libbfd:
> > +	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
> 
> Duplicate PACKAGE definitions.  It seems only one is needed and it
> should look like a normal C string like -DPACKAGE='"perf"' IMHO.

Agreed - I sent the fix in a separate mail.

Thanks,

	Ingo

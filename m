Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbaFYON5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:13:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbaFYONz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:13:55 -0400
Message-ID: <1403705624.755.85.camel@deneb.redhat.com>
Subject: Re: [PATCH] perf: fix arm64 build error
From: Mark Salter <msalter@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Date: Wed, 25 Jun 2014 10:13:44 -0400
In-Reply-To: <CAFrcx1n4Txz0a59omx3OKPQQR+AYV2NgNuJ16O01z_7PtGcJpw@mail.gmail.com>
References: <1403666205-25346-1-git-send-email-msalter@redhat.com>
	 <CAFrcx1n4Txz0a59omx3OKPQQR+AYV2NgNuJ16O01z_7PtGcJpw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 10:12 +0200, Jean Pihet wrote:
> Hi Mark,
> 
> On 25 June 2014 05:16, Mark Salter <msalter@redhat.com> wrote:
> > I'm seeing the following build error on arm64:
> >
> >   In file included from util/event.c:3:0:
> >   util/event.h:95:17: error: 'PERF_REGS_MAX' undeclared here (not in a function)
> >     u64 cache_regs[PERF_REGS_MAX];
> >                  ^
> >
> > This patch adds a PEFF_REGS_MAX definition for arm64.
> s/PEFF_REGS_MAX/PERF_REGS_MAX
> 
> >
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> 
> Acked-by: Jean Pihet <jean.pihet@linaro.org>
> 
> Thanks!
> 
> Note: Do you have any performance figure with and without the caching
> code in perf?

Sorry, I don't.



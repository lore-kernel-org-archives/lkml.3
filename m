Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3KMNbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:31:34 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56050 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab3KMNbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:31:32 -0500
Date: Wed, 13 Nov 2013 14:31:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Tweak summary output
Message-ID: <20131113133126.GA26861@gmail.com>
References: <1384345308-24404-1-git-send-email-penberg@kernel.org>
 <20131113125734.GA22140@gmail.com>
 <CAOJsxLEFVwiz3pwKoJdy3ARKd_Rk0Mkcy7k62ZqJJE9_f5s2RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEFVwiz3pwKoJdy3ARKd_Rk0Mkcy7k62ZqJJE9_f5s2RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Wed, Nov 13, 2013 at 2:57 PM, Ingo Molnar <mingo@kernel.org> wrote:
> > Are you convinced about double-digit precision output for percentages?
> >
> > I think it suggest a false level of accuracy, but YYMV - typographically
> > xx.yy certainly looks nicer than xx.y (it's more symmetric).
> 
> Yeah, I think it's OK.

ok.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

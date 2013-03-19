Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3CSLrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:47:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54005
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab3CSLrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:47:03 -0400
Message-ID: <1363693618.22553.33.camel@laptop>
Subject: Re: [PATCHv3] perf: Fix vmalloc ring buffer free function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 19 Mar 2013 12:46:58 +0100
In-Reply-To: <20130318190548.GA18920@krava.brq.redhat.com>
References: <1363023885.14933.16.camel@laptop>
	 <20130311180229.GI13679@krava.brq.redhat.com>
	 <20130312100502.GC1348@krava.brq.redhat.com>
	 <1363084030.14933.23.camel@laptop>
	 <20130312135219.GA32001@krava.brq.redhat.com>
	 <1363101972.24558.3.camel@laptop>
	 <20130312153609.GC32001@krava.brq.redhat.com>
	 <1363105490.24558.12.camel@laptop>
	 <20130312170416.GD32001@krava.brq.redhat.com>
	 <20130313111557.GC1064@krava.brq.redhat.com>
	 <20130318190548.GA18920@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> are you going to include that, or should I repost it?

Ah, please repost (and prettify) it, I'm still very limited in the
amount of work that I can do :/


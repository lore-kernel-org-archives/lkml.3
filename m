Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaFTPZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:25:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:41087 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbaFTPZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:25:44 -0400
Date: Fri, 20 Jun 2014 12:25:40 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf kvm: move perf_kvm__mmap_read into session utils
Message-ID: <20140620152540.GI31524@kernel.org>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <1403261389-13423-7-git-send-email-stfomichev@yandex-team.ru>
 <20140620144427.GF31524@kernel.org>
 <20140620150702.GL15620@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620150702.GL15620@stfomichev-desktop.yandex.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 20, 2014 at 07:07:02PM +0400, Stanislav Fomichev escreveu:
> > I.e. what we need from perf_session is just the ordered_samples bits,
> > perhaps in its current form, perhaps rewritten, see (renewed) discussion
> > involving David Ahern and Jiri Olsa.
> Do you mean you want to pull (at some point) Jiri's patches and want to use
> just event ordering part in perf trace, not a full blown perf_session?

Right.

> I'll try to have a look how I can use these patches for ordered trace.

Thanks, reviewing his work is the logical next step for you since you're
working on this, great move!

- Arnaldo

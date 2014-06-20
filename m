Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538AbaFTPHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:07:10 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:48699 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932468AbaFTPHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:07:06 -0400
X-Yandex-Uniq: 94bd9dde-c9a9-4412-a077-79aa2ace7377
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Fri, 20 Jun 2014 19:07:02 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf kvm: move perf_kvm__mmap_read into session utils
Message-ID: <20140620150702.GL15620@stfomichev-desktop.yandex.net>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <1403261389-13423-7-git-send-email-stfomichev@yandex-team.ru>
 <20140620144427.GF31524@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620144427.GF31524@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I.e. what we need from perf_session is just the ordered_samples bits,
> perhaps in its current form, perhaps rewritten, see (renewed) discussion
> involving David Ahern and Jiri Olsa.
Do you mean you want to pull (at some point) Jiri's patches and want to use
just event ordering part in perf trace, not a full blown perf_session?
I'll try to have a look how I can use these patches for ordered trace.

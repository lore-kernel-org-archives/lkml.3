Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3HZDpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 23:45:55 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:51625 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3HZDpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 23:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130823035344.GB5098@redhat.com>
References: <20130807055157.GA32278@redhat.com>
	<CAJd=RBCJv7=Qj6dPW2Ha=nq6JctnK3r7wYCAZTm=REVOZUNowg@mail.gmail.com>
	<20130807153030.GA25515@redhat.com>
	<CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
	<20130819231836.GD14369@redhat.com>
	<CAJd=RBA-UZmSTxNX63Vni+UPZBHwP4tvzE_qp1ZaHBqcNG7Fcw@mail.gmail.com>
	<20130821204901.GA19802@redhat.com>
	<CAJd=RBBNCf5_V-nHjK0gOqS4OLMszgB7Rg_WMf4DvL-De+ZdHA@mail.gmail.com>
	<20130823032127.GA5098@redhat.com>
	<CAJd=RBArkh3sKVoOJUZBLngXtJubjx4-a3G6s7Tn0N=Pr1gU4g@mail.gmail.com>
	<20130823035344.GB5098@redhat.com>
Date: Mon, 26 Aug 2013 11:45:53 +0800
Message-ID: <CAJd=RBBtY-nJfo9nzG5gtgcvB2bz+sxpK5kX33o1sLeLhvEU1Q@mail.gmail.com>
Subject: Re: unused swap offset / bad page map.
From: Hillf Danton <dhillf@gmail.com>
To: Dave Jones <davej@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 11:53 AM, Dave Jones <davej@redhat.com> wrote:
>
> It actually seems worse, seems I can trigger it even easier now, as if
> there's a leak.
>
Can you please try the new fix for TLB flush?

commit  2b047252d087be7f2ba
Fix TLB gather virtual address range invalidation corner cases

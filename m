Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3J2N7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:59:01 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45787 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3J2N67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:58:59 -0400
Date: Tue, 29 Oct 2013 14:58:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        Runzhen Wang <icycoder@gmail.com>
Subject: Re: [PATCH 14/16] perf kvm: reuse some code of
 perf_kvm__timerfd_create()
Message-ID: <20131029135856.GA25191@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
 <1369527896-3650-15-git-send-email-dsahern@gmail.com>
 <20130912130849.GA23826@gmail.com>
 <5231C2EF.8080200@gmail.com>
 <20130912134058.GF23826@gmail.com>
 <20131029132304.GA22052@gmail.com>
 <526FBDEF.8090109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526FBDEF.8090109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> >Btw., this build failure is still there today:
> 
> Right, I put together a patch on Sept 14th and got distracted. 
> I'll rebase to top of tree, update per the new feature tests and 
> send it out today.

Yeah, it would be fine against the new feature tests, I don't think 
building on such an old distro is an outright regression.

Thanks,

	Ingo

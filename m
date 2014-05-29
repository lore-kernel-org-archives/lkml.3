Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaE2H2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:28:25 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61428 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbaE2H2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:28:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140529070430.GA2602@dhcp-27-189.brq.redhat.com>
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
	<1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
	<CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com>
	<CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
	<20140528172150.GA3261@dhcp-27-189.brq.redhat.com>
	<CACVXFVPQR6xdzJxakPhA_rMiNyquooEGt_XS50-nZmyY0P+0CA@mail.gmail.com>
	<5386CE5A.6070708@intel.com>
	<20140529070430.GA2602@dhcp-27-189.brq.redhat.com>
Date: Thu, 29 May 2014 15:28:22 +0800
Message-ID: <CACVXFVOp9B3dqEAZqcJpCfoWK9tg7+2a-0dnb9a-VC6tzAfmcA@mail.gmail.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
From: Ming Lei <tom.leiming@gmail.com>
To: Maurizio Lombardi <mlombard@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Jet Chen <jet.chen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 2:06 PM, Jet Chen <jet.chen@intel.com> wrote:
> On 05/29/2014 01:44 AM, Ming Lei wrote:
> This patch works, thanks.
>
> Tested-by: Jet Chen <jet.chen@intel.com>

Jet, thanks for your test.


On Thu, May 29, 2014 at 3:04 PM, Maurizio Lombardi <mlombard@redhat.com> wrote:
>
> Jens, can you review and merge it?

I will prepare a formal one for merging.

It should be better to merge it via -mm tree because the
other two commits which caused the regression are from
-mm.

Thanks,
-- 
Ming Lei

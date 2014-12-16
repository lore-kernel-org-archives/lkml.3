Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaLPCWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:22:37 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36689 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLPCWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:22:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAG4TOxP9WFHALPb0y0eKFup6uhszXfd+hLcwZ98kZUVaR_9j4w@mail.gmail.com>
References: <20141216124750.153e3fdd@canb.auug.org.au> <CAG4TOxP9WFHALPb0y0eKFup6uhszXfd+hLcwZ98kZUVaR_9j4w@mail.gmail.com>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 15 Dec 2014 18:22:13 -0800
X-Google-Sender-Auth: c8EI-F32d3uY45P84aQaLg6agiY
Message-ID: <CAG4TOxMerrp0wHZ=cA-29iDvnZ8HsdqTb_1ftCFB7XHu70_iZg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 5:56 PM, Roland Dreier <roland@kernel.org> wrote:
> I'll add a partial revert of that patch to my tree to get back the
> now-used enum values.

I rebased my tree on top of the merge-window merge of davem's tree,
and added the missing flag on top of the "remove this flag" commit.

 - R.

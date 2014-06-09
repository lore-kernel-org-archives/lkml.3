Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaFIToo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:44:44 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:36126 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFITol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAG4TOxMbXJeq848LuzJvsz23th4Wh7NZ6qT9o+pdv4fOdu=o=Q@mail.gmail.com>
References: <fc0ae2c3-2661-48ba-957a-66cbb0cfc33e@CMEXHTCAS1.ad.emulex.com>
	<538F4B66.6080906@opengridcomputing.com>
	<CAG4TOxMbXJeq848LuzJvsz23th4Wh7NZ6qT9o+pdv4fOdu=o=Q@mail.gmail.com>
Date: Mon, 9 Jun 2014 22:44:40 +0300
Message-ID: <CAJZOPZLqmq1XMoyjv0OMTv8iX0Otvo=bm-rrwa3EfupUYgyGKQ@mail.gmail.com>
Subject: Re: [PATCH for-next 00/15] Bug fixes for ocrdma driver
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Roland Dreier <roland@kernel.org>,
        Selvin Xavier <selvin.xavier@emulex.com>
Cc: Steve Wise <swise@opengridcomputing.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 8:06 PM, Roland Dreier <roland@kernel.org> wrote:
> On Wed, Jun 4, 2014 at 9:37 AM, Steve Wise <swise@opengridcomputing.com> wrote:
>> Seems like the subject lines in each patch are getting truncated?
> Yes, truncated in patchwork too -- for example:
> https://patchwork.kernel.org/patch/4292461/
>
> Please fix and resend.

Roland, from quick looking on this series of fifteen patches, only 1/3
of them (4/5/12/14) have non-empty change-log. I would expect kernel
work which goes upstream through linux-rdma to use a bit of higher
standards, agree?

Selvin, can you sit down and come up with change-logs to your driver updates?

Or.

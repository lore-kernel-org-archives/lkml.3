Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaIJJ2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:28:14 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48192 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaIJJ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:28:12 -0400
Message-ID: <541019A8.3070005@dev.mellanox.co.il>
Date: Wed, 10 Sep 2014 12:28:08 +0300
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Haggai Eran <haggaie@mellanox.com>, Roland Dreier <roland@kernel.org>,
        Latchesar Ionkov <lionkov@lanl.gov>
CC: Or Gerlitz <gerlitz.or@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com> <5405D2D8.1040700@mellanox.com> <CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com> <CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com> <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com> <540F0CD8.9070002@mellanox.com> <54101123.2080208@mellanox.com>
In-Reply-To: <54101123.2080208@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/2014 11:51 AM, Haggai Eran wrote:
<SNIP>
>
> The main benefits of ODP is the simplified programming model, simplified
> management, and avoiding worst-case memory commitment.
> For example, we were able to run multiple concurrent instances of iSER
> targets, allowing over-commitment that otherwise wouldn’t be possible.

Just wanted to add that we're talking about TGT which is a user-space 
target, thus it's RDMA memory regions were allowed to be pageable (i.e. 
not pinned).

Cheers,
Sagi.

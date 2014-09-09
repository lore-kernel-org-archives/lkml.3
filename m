Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaIIOVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:21:37 -0400
Received: from eu1sys200aog127.obsmtp.com ([207.126.144.176]:55231 "EHLO
	eu1sys200aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbaIIOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:21:35 -0400
Message-ID: <540F0CD8.9070002@mellanox.com>
Date: Tue, 9 Sep 2014 17:21:12 +0300
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>, Latchesar Ionkov <lionkov@lanl.gov>
CC: Or Gerlitz <gerlitz.or@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com> <5405D2D8.1040700@mellanox.com> <CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com> <CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com> <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com>
In-Reply-To: <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.0.34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 00:15, Roland Dreier wrote:
> Have you done any review or testing of these changes?  If so can you
> share the results?

We have tested this feature thoroughly inside Mellanox. We ran random
tests that performed MR registrations, memory mappings and unmappings,
calls to madvise with MADV_DONTNEED for invalidations, sending and
receiving of data, and RDMA operations. The test validated the integrity
of the data, and we verified the integrity of kernel memory by running
the tests under a debugging kernel.

Best regards,
Haggai


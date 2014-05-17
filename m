Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaEQUwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 16:52:13 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43259 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaEQUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 16:52:11 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1405131338030.16459@pobox.suse.cz>
References: <1399810512-30774-1-git-send-email-ogerlitz@mellanox.com>
	<alpine.LNX.2.00.1405131338030.16459@pobox.suse.cz>
Date: Sat, 17 May 2014 23:52:10 +0300
Message-ID: <CAJZOPZJVxF6A-3s16feqoWCb5gOLTjyUmB3F+st1+1QWp+bJnQ@mail.gmail.com>
Subject: Re: [PATCH v1 for-next 0/3] IB: Use GFP_NOIO calls in IPoIB connected
 mode TX path
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>, Roland Dreier <roland@kernel.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>, Mel Gorman <mgorman@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 2:38 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sun, 11 May 2014, Or Gerlitz wrote:

>> This series is a refactored form of the one posted by Jiri Kosina
>> to LKML and netdev according to the discussion that followed
>> and the guidelines you provided here https://lkml.org/lkml/2014/3/5/250

>> Basically, the functionality changes introduced by this series fully
>> reside on the IB side of things, so I am only posting the actual patches
>> to linux-rdma with CC on the cover-letter to the lists that were on V0.

> Thanks, I am fine with my Signoff on that.
> Roland, is this going to be merged by you, or should this go to DaveM directly?

Roland, we're soon on -rc6 and there's no reason for this to miss
3.16, could you please comment whether you want it to go through your
tree or net-next?

> Jiri Kosina
> SUSE Labs

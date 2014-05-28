Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaE1Ftr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 01:49:47 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:65466 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaE1Ftq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 01:49:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140527.152414.1304343647733553805.davem@davemloft.net>
References: <1401029247-15196-1-git-send-email-amirv@mellanox.com>
	<1401029247-15196-2-git-send-email-amirv@mellanox.com>
	<20140527.152414.1304343647733553805.davem@davemloft.net>
Date: Wed, 28 May 2014 08:49:44 +0300
Message-ID: <CAJZOPZJ=sC9ZNdU5O+XLapO49HhcJmn5579o8DMva3Og4pwyJw@mail.gmail.com>
Subject: Re: [PATCH net-next V6 1/2] cpumask: Utility function to set n'th cpu
 - local cpu first
From: Or Gerlitz <or.gerlitz@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Amir Vadai <amirv@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Petrilin <yevgenyp@mellanox.com>,
        Yuval Atias <yuvala@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:24 PM, David Miller <davem@davemloft.net> wrote:

> I would like someone who cares about these cpumask interfaces to provide
> a review.

understood, still, looking in the git log of that file didn't yield
much only 1-2 commits per years for 2011/12/13, so, any concrete
suggestion?

Or.

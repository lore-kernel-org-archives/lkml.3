Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaDOM4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:56:14 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35184 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaDOM4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:56:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140415125111.GG1863@htj.dyndns.org>
References: <1397566065-3028-1-git-send-email-nasa4836@gmail.com> <20140415125111.GG1863@htj.dyndns.org>
From: Zhan Jianyu <nasa4836@gmail.com>
Date: Tue, 15 Apr 2014 20:55:31 +0800
Message-ID: <CAHz2CGXimrWPjOshDDbJ2xjuFgzYxEOm43w+zmfXXqxxLSwGsA@mail.gmail.com>
Subject: Re: [PATCH] cgroup: print pretty format in /proc/cgroups
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 8:51 PM, Tejun Heo <tj@kernel.org> wrote:
> The problem there is that there could be programs / scripts parsing it
> assuming single tab between entries.  It surely is ugly but do we
> care?

Oh, you are right. It is an exposed user interface. This will make lots of
administrator unhappy ;-(

Thanks,
Jianyu Zhan

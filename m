Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaI3Dns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:43:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:64961 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaI3Dnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:43:46 -0400
MIME-Version: 1.0
Date: Mon, 29 Sep 2014 20:43:46 -0700
Message-ID: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
Subject: Please backport commit 3812c8c8f39 to stable
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Johannes and Greg


Please consider to backport the following commit to stable kernels < 3.12.

commit 3812c8c8f3953921ef18544110dafc3505c1ac62
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Thu Sep 12 15:13:44 2013 -0700

    mm: memcg: do not trap chargers with full callstack on OOM

It should solve some soft lockup I observed on different machines
recently. For me myself, I only care about 3.10. :-p

commit 4942642080ea82d99ab5b65 (mm: memcg: handle non-error OOM
situations more gracefully) seems needed as a followup. Johannes
should know much better than I do.

Let me know if you need any more information or help from me.

Thanks much!

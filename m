Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbbAZSgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:36:13 -0500
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:57910 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624AbbAZSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:35:20 -0500
Date: Mon, 26 Jan 2015 12:35:19 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
In-Reply-To: <20150126172832.GC22681@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.11.1501261235030.16786@gentwo.org>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150114165036.GI4706@dhcp22.suse.cz> <54B7F7C4.2070105@codeaurora.org> <20150116154922.GB4650@dhcp22.suse.cz> <54BA7D3A.40100@codeaurora.org> <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
 <20150126172832.GC22681@dhcp22.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Michal Hocko wrote:
> >From 12d00a8066e336d3e1311600b50fa9b588798448 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 26 Jan 2015 18:07:51 +0100
> Subject: [PATCH] vmstat: Do not use deferrable delayed work for vmstat_update

Acked-by: Christoph Lameter <cl@linux.com>

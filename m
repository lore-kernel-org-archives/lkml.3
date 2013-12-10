Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3LJIND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:13:03 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43418 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3LJIM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:12:58 -0500
MIME-Version: 1.0
In-Reply-To: <252512613b0823c84478428f5543d2140d1291a5.1386571280.git.vdavydov@parallels.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
	<252512613b0823c84478428f5543d2140d1291a5.1386571280.git.vdavydov@parallels.com>
Date: Tue, 10 Dec 2013 12:12:57 +0400
Message-ID: <CAA6-i6rTyBtiyp9ed6DMj+U_b29Rwu7By997391WoyVxZ3YaoQ@mail.gmail.com>
Subject: Re: [PATCH v13 14/16] vmpressure: in-kernel notifications
From: Glauber Costa <glommer@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>,
        John Stultz <john.stultz@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 12:05 PM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> From: Glauber Costa <glommer@openvz.org>
>
> During the past weeks, it became clear to us that the shrinker interface

It has been more than a few weeks by now =)

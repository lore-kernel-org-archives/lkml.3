Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaGWSJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:09:04 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:61588 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbaGWSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:08:58 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140723150608.GF1725@cmpxchg.org>
References: <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
	<20140715082545.GA9366@dhcp22.suse.cz>
	<20140715121935.GB9366@dhcp22.suse.cz>
	<20140718071246.GA21565@dhcp22.suse.cz>
	<20140718144554.GG29639@cmpxchg.org>
	<CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
	<20140719173911.GA1725@cmpxchg.org>
	<20140722150825.GA4517@dhcp22.suse.cz>
	<CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
	<20140723143847.GB16721@dhcp22.suse.cz>
	<20140723150608.GF1725@cmpxchg.org>
Date: Wed, 23 Jul 2014 20:08:57 +0200
Message-ID: <CAJfpegs-k5QC+42SzLKUSaHrdPxWBaT_dF+SOPqoDvg8h5p_Tw@mail.gmail.com>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
From: Miklos Szeredi <miklos@szeredi.hu>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 5:06 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Can the new page be anything else than previous page cache?

It could be an ordinary pipe buffer too.  Stealable as well (see
generic_pipe_buf_steal()).

Thanks,
Miklos

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3IEUFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:05:41 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44864 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab3IEUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130827235227.99DB95A41D6@corp2gmr1-2.hot.corp.google.com>
References: <20130827235227.99DB95A41D6@corp2gmr1-2.hot.corp.google.com>
Date: Thu, 5 Sep 2013 13:05:38 -0700
Message-ID: <CAGa+x85d-RWYPkmTVapzcYFEzPhUU7YLJHZVGK0cGc=AudYubQ@mail.gmail.com>
Subject: Re: mmotm 2013-08-27-16-51 uploaded
From: Kevin Hilman <khilman@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, vbabka@suse.cz,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 4:52 PM,  <akpm@linux-foundation.org> wrote:

> This mmotm tree contains the following patches against 3.11-rc7:
> (patches marked "*" will be included in linux-next)

[...]

> * mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

As has already been pointed out[1], this one introduced a new warning
in -next (also lovingly acknowledged in the mmotm series file[2]) and
it seems that Vlastimil has posted an updated version[3].  Any plans
to pick up the new version for -next (or at least drop the one causing
the new warning?)

Kevin


[1] http://marc.info/?l=linux-mm&m=137764226521459&w=2
[2] http://www.ozlabs.org/~akpm/mmotm/series
[2] http://marc.info/?l=linux-mm&m=137778135631351&w=2

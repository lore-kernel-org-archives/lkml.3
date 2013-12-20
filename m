Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3LTQDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:03:22 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:42148 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3LTQDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:03:20 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1387461299.git.liwang@ubuntukylin.com>
References: <cover.1387461299.git.liwang@ubuntukylin.com>
Date: Fri, 20 Dec 2013 11:03:19 -0500
Message-ID: <CANP1eJFyxBMg3x7Vbrdf2=CA2Oau6gLjpTduZgSadtMCje48iw@mail.gmail.com>
Subject: Re: [PATCH 0/2] ceph fscache: uncaching single no data page when error
From: Milosz Tanski <milosz@adfin.com>
To: Li Wang <liwang@ubuntukylin.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks legit to me.

- M

P.S: Sorry for the first HTML email, I blame gmail.

On Thu, Dec 19, 2013 at 9:03 AM, Li Wang <liwang@ubuntukylin.com> wrote:
> Currently, if one new page allocated into fscache in readpage(), however,
> with no data read into due to error encountered during reading from OSDs,
> the slot in fscache is not uncached. This patch fixes this.
>
> Li Wang (2):
>   ceph: Introduce a routine for uncaching single no data page from
>     fscache
>   ceph: Uncaching no data page from fscache in readpage()
>
>  fs/ceph/addr.c  |    1 +
>  fs/ceph/cache.h |   13 +++++++++++++
>  2 files changed, 14 insertions(+)
>
> --
> 1.7.9.5
>



-- 
Milosz Tanski
CTO
10 East 53rd Street, 37th floor
New York, NY 10022

p: 646-253-9055
e: milosz@adfin.com

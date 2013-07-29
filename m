Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3G2DM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 23:12:58 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:60793 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab3G2DM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 23:12:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130729024546.GD13468@dastard>
References: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
	<20130726025009.GE21982@dastard>
	<CAEH94Lh-UCCEs7hQi_t5v+X+ER1DH9dCtjr6e9GVNX5KJ-f1hQ@mail.gmail.com>
	<20130726113521.GM13468@dastard>
	<CAEH94Ljpih875VOEdCY9Z9CdMF_1DesW7dsz_k7Zm=xt165w5A@mail.gmail.com>
	<20130729024546.GD13468@dastard>
Date: Mon, 29 Jul 2013 11:12:55 +0800
Message-ID: <CAEH94LgBN70u8+jnd4y3jsxf53U07CG=HWfB9VOvE-VoZG9SKw@mail.gmail.com>
Subject: Re: [PATCH] xfs: introduce object readahead to log recovery
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:45 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jul 29, 2013 at 09:38:11AM +0800, Zhi Yong Wu wrote:
>> By the way, how do you try the workload which has nothing but dirty
>> dquote objects?
>
> Create quota limits for non-existent users. That will allocate the
> dquots and dirty them.
>
> Or if you already have a few hundred thousand dquots, just change
> the limits on them all to get them logged and dirty...
OK, thanks.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu

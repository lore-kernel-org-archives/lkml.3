Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaESUy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:54:26 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52678 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaESUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140519195233.GX15585@mwanda>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-3-git-send-email-matlackdavid@gmail.com>
 <20140519092119.GT15585@mwanda> <CANoiuGLjBwitL_==2xVQ_021p=3uOCf2qwqWYdrmiRE7rQM0FQ@mail.gmail.com>
 <20140519195233.GX15585@mwanda>
From: David Matlack <matlackdavid@gmail.com>
Date: Mon, 19 May 2014 13:54:02 -0700
Message-ID: <CANoiuGKKjEvLzb70JNQWe=P6GY3vm_OKDuUz+m6eW0t6qVvQpw@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: slicoss: remove slic_reg_params struct
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Lior Dotan <liodot@gmail.com>, linux-kernel@vger.kernel.org,
        charrer@alacritech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:52 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
>
> You have to understand that I review a lot of staging patches every day.
> Most patches try to remove struct members but the code should still work
> exactly as it did before (a clean up).  Some patches remove struct
> members and the behavior changes.  Hopefully it's deliberate and the
> changelog mentions that it is a bug fix.  If it changes the run time,
> and not deliberately then that's a bug.
>

Ah I see. This patch does indeed change the behavior. Since I plan to resend
the other patch in this series, I'll fix the changelog for this patch as well.

Thanks for the review.

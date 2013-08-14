Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab3HNOZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:25:07 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45945 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3HNOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:25:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130814115218.GC8044@elgon.mountain>
References: <20130814115218.GC8044@elgon.mountain>
Date: Wed, 14 Aug 2013 07:25:03 -0700
X-Google-Sender-Auth: A1kSxd7na_PMcAsp7jugSTMzV3Q
Message-ID: <CAGXu5j+tSY1MPTV383ij6Jgqf+dq+QVDtpcWdXmgNKL8gpc5zQ@mail.gmail.com>
Subject: Re: [patch] pstore: d_alloc_name() doesn't return an ERR_PTR
From: Kees Cook <keescook@chromium.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 4:52 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> d_alloc_name() returns NULL on error.  Also I changed the error code
> from -ENOSPC to -ENOMEM to reflect that we were short on RAM not disk
> space.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks for the catch!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security

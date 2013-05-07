Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3EGPqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:46:36 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:39851 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3EGPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:46:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9w_PpotgpN+KZKs79W4xZrLsBNxRsh+DjspeMxc+vxpA@mail.gmail.com>
References: <CAPgLHd9w_PpotgpN+KZKs79W4xZrLsBNxRsh+DjspeMxc+vxpA@mail.gmail.com>
Date: Tue, 7 May 2013 08:46:34 -0700
X-Google-Sender-Auth: G37ZaNtLM0n_VTntIW4YhJKNSAE
Message-ID: <CAGXu5jL0WerhTQ_7m84LkWexoS57_5V=6-Cr_CZ6qhE6by215g@mail.gmail.com>
Subject: Re: [PATCH] pstore/ram: fix error return code in ramoops_probe()
From: Kees Cook <keescook@chromium.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, yongjun_wei@trendmicro.com.cn,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 4:39 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Good catch, thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security

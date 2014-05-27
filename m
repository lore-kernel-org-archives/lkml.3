Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaE0StG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:49:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaE0StE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:49:04 -0400
Date: Tue, 27 May 2014 11:52:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heesub Shin <heesub.shin@samsung.com>
Cc: devel@driverdev.osuosl.org, Sunghwan Yun <sunghwan.yun@samsung.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: Re: [PATCH 1/9] staging: ion: tidy up a bit
Message-ID: <20140527185238.GA2115@kroah.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 07:04:53PM +0900, Heesub Shin wrote:
> For aesthetics and readability, rename goto labels, remove
> useless code lines, and clarify function return type.
> 
> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
> ---
>  drivers/staging/android/ion/ion_page_pool.c   |  2 +-
>  drivers/staging/android/ion/ion_priv.h        |  2 +-
>  drivers/staging/android/ion/ion_system_heap.c | 57 ++++++++++++---------------
>  3 files changed, 28 insertions(+), 33 deletions(-)

For this whole series, I need someone from the Android team, or John, to
ack them, as I have no way of testing.

thanks,

greg k-h

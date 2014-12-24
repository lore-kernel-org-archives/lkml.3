Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaLXHVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:21:10 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38014 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaLXHVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:21:07 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Drivers: bcma: Fix three coding style issues, more than 80 characters per line.
References: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com>
Date: Wed, 24 Dec 2014 09:20:59 +0200
In-Reply-To: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com>
	(Oscar Forner Martinez's message of "Tue, 23 Dec 2014 23:55:09 +0000")
Message-ID: <877fxhbjj8.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oscar Forner Martinez <oscar.forner.martinez@gmail.com> writes:

> Three lines with more than 80 characters per line have been split in several lines.
>
> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
> ---
>  drivers/bcma/driver_chipcommon.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Just to handle the bureaucracy before v2 is submitted:

To which tree should this go to? I see that earlier John has applied
patches to drivers/bcma/, but what about now? Should I take these? John,
any suggestions?

Oscar, the patchwork entry for this patch looked odd. I'm guessing it
was because your time (or timezone) is wrong:

https://patchwork.kernel.org/patch/5535751/

-- 
Kalle Valo

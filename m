Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaLXP0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 10:26:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53272 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaLXP0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 10:26:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Fariya Fatima <fariyaf@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] rsi: fix memory leak in rsi_load_ta_instructions()
References: <1418420635-23869-1-git-send-email-khoroshilov@ispras.ru>
Date: Wed, 24 Dec 2014 17:26:39 +0200
In-Reply-To: <1418420635-23869-1-git-send-email-khoroshilov@ispras.ru> (Alexey
	Khoroshilov's message of "Sat, 13 Dec 2014 00:43:55 +0300")
Message-ID: <87wq5h83ww.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Khoroshilov <khoroshilov@ispras.ru> writes:

> Memory allocated by kmemdup() in rsi_load_ta_instructions() is leaked.
> But duplication of firmware data here is useless,
> so the patch removes kmemdup() at all.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaE0She (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:37:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35127 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbaE0Shb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:37:31 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Heesub Shin <heesub.shin@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] staging: ion: remove order argument from free_buffer_page()
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
	<1401098701-24049-7-git-send-email-heesub.shin@samsung.com>
Date: Tue, 27 May 2014 11:37:28 -0700
In-Reply-To: <1401098701-24049-7-git-send-email-heesub.shin@samsung.com>
	(Heesub Shin's message of "Mon, 26 May 2014 19:04:59 +0900")
Message-ID: <vnkw1tvf5aqf.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26 2014 at 03:04:59 AM, Heesub Shin <heesub.shin@samsung.com> wrote:
> Not that the pages returned from the pool are compound pages, we do not
> need to pass the order information to free_buffer_page().

s/Not/Now/


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3A1Vqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:46:32 -0500
Received: from void.printf.net ([89.145.121.20]:56718 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab3A1Vqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:46:30 -0500
From: Chris Ball <cjb@laptop.org>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v1] mmc: core: move the cache disabling operation to mmc_suspend
References: <1358681368-13044-1-git-send-email-merez@codeaurora.org>
Date: Mon, 28 Jan 2013 16:45:45 -0500
In-Reply-To: <1358681368-13044-1-git-send-email-merez@codeaurora.org> (Maya
	Erez's message of "Sun, 20 Jan 2013 13:29:16 +0200")
Message-ID: <87k3qx6kxi.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 20 2013, Maya Erez wrote:
> Cache control is an eMMC feature and in therefore should be
> part of MMC's bus resume operations, performed in mmc_suspend,
> rather than in the generic mmc_suspend_host().
>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

Thanks, pushed to mmc-next for 3.9.

(Please ignore the mail I just sent asking you to repost this patch --
I was confused by the v1 and change in Subject line.)

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

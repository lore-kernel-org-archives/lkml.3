Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3EZRWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 13:22:12 -0400
Received: from void.printf.net ([89.145.121.20]:36335 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab3EZRWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 13:22:11 -0400
From: Chris Ball <cjb@laptop.org>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v3] mmc: card: Adding support for sanitize in eMMC 4.5
References: <1366288936-26373-1-git-send-email-merez@codeaurora.org>
Date: Sun, 26 May 2013 13:22:06 -0400
In-Reply-To: <1366288936-26373-1-git-send-email-merez@codeaurora.org> (Maya
	Erez's message of "Thu, 18 Apr 2013 15:41:55 +0300")
Message-ID: <87ppwdr70h.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maya,

On Thu, Apr 18 2013, Maya Erez wrote:
> The sanitize support is added as a user-app ioctl call, and
> was removed from the block-device request, since its purpose is
> to be invoked not via File-System but by a user.
> This feature deletes the unmap memory region of the eMMC card,
> by writing to a specific register in the EXT_CSD.
> unmap region is the memory region that was previously deleted
> (by erase, trim or discard operation).
> In order to avoid timeout when sanitizing large-scale cards,
> the timeout for sanitize operation is 240 seconds.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

Thanks, pushed to mmc-next for 3.11.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

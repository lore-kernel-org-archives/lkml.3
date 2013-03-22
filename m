Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161046Ab3CVQu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:50:58 -0400
Received: from void.printf.net ([89.145.121.20]:38440 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161001Ab3CVQu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:50:57 -0400
From: Chris Ball <cjb@laptop.org>
To: Markos Chandras <markos.chandras@imgtec.com>
Cc: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "Jaehoon Chung" <jh80.chung@samsung.com>
Subject: Re: [PATCH 2/3] dw_mmc: Avoid adding the number of transmitted bytes twice
References: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
	<1363085593-22214-2-git-send-email-markos.chandras@imgtec.com>
Date: Fri, 22 Mar 2013 12:50:51 -0400
In-Reply-To: <1363085593-22214-2-git-send-email-markos.chandras@imgtec.com>
	(Markos Chandras's message of "Tue, 12 Mar 2013 10:53:12 +0000")
Message-ID: <87zjxvml90.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 12 2013, Markos Chandras wrote:
> Previously, it was possible to add either 0 bytes or add nbytes
> twice if we broke out of the outer loop and then carry on to the
> "done" label. This is now fixed by adding the transferred bytes
> right after the pull/pop operation
>
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Chris Ball <cjb@laptop.org>

Thanks, pushed to mmc-next for 3.10.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

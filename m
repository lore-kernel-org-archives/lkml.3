Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaCCTCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:02:01 -0500
Received: from void.printf.net ([89.145.121.20]:54093 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaCCTB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:01:58 -0500
From: Chris Ball <chris@printf.net>
To: <balbi@ti.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, <tgih.jun@samsung.com>,
        <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: host: dw: fix possible build error
References: <1393340264-22687-1-git-send-email-balbi@ti.com>
	<530D134F.5090403@samsung.com> <20140303180614.GA31301@saruman.home>
Date: Mon, 03 Mar 2014 19:01:53 +0000
In-Reply-To: <20140303180614.GA31301@saruman.home> (Felipe Balbi's message of
	"Mon, 3 Mar 2014 12:06:14 -0600")
Message-ID: <86vbvvqf6m.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 03 2014, Felipe Balbi wrote:
>> When you send the patch related with dw_mmc controller, could you use
>> the prefix "mmc: dw_mmc:"?  "mmc: dw_mmc: fix possible build error"
>
> sure, no problem. Do I *really* need to resend though ? It's already
> -rc5 and I still don't see this patch merged.

No need to resend, I can fix this up -- pushed to mmc-next, thanks.

- Chris.
-- 
Chris Ball   <chris@printf.net>   <http://printf.net/>

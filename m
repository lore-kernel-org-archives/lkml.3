Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab3LIIOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:14:19 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:47183 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3LIIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:14:18 -0500
Date: Mon, 9 Dec 2013 09:14:15 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: hskinnemoen@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] avr32: remove deprecated IRQF_DISABLED
Message-ID: <20131209081415.GA8849@samfundet.no>
References: <20131013072003.GA11195@samfundet.no>
 <1386566211-19536-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386566211-19536-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 09 Dec 2013 06:16:51 +0100 or thereabout, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

I'll pull it into the for-linus branch in
git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git

> ---
>  arch/avr32/kernel/time.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt

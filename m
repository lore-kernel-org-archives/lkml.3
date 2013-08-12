Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3HLUGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:06:38 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:58611 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3HLUGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:06:35 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2013 16:06:34 EDT
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Eric Miao <eric.y.miao@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 9/16] arch/arm/mach-pxa/mioa701.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376239917-15594-10-git-send-email-Julia.Lawall@lip6.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 12 Aug 2013 21:58:30 +0200
In-Reply-To: <1376239917-15594-10-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Sun, 11 Aug 2013 18:51:50 +0200")
Message-ID: <87r4dyy93t.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
> arity of the called function.

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

As a side I'm curious why this change didn't touch also :
sound/soc/pxa/mioa701_wm9713.c

If it does, this ack stands as well for the other file (with removal of the
#define in mioa701_wm9713.c).

Cheers.

--
Robert

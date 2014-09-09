Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaIIS0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:26:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59327 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaIIS0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:26:42 -0400
Date: Tue, 09 Sep 2014 11:26:40 -0700 (PDT)
Message-Id: <20140909.112640.131028033967197328.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/3] sparc/uapi: Add definition of TIOC[SG]RS485
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410286110-24956-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1410286110-24956-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 11:26:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue,  9 Sep 2014 20:08:30 +0200

> diff --git a/arch/sparc/include/uapi/asm/ioctls.h b/arch/sparc/include/uapi/asm/ioctls.h
> index 897d172..4e1c5da 100644
> --- a/arch/sparc/include/uapi/asm/ioctls.h
> +++ b/arch/sparc/include/uapi/asm/ioctls.h
> @@ -24,6 +24,8 @@
>  #define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
>  #define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
>  #define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
> +#define TIOCGRS485	0x542E
> +#define TIOCSRS485	0x542F

Please follow the ioctl numbering scheme used by the particular
architecture UAPI file you are editing.

Since Sparc here is using incrementing _IO*() values, including the type
for the object passed in/out of the ioctl, you should do similarly for
TIOC{G,S}RS485.

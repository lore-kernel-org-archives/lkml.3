Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3KTSyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:54:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36160 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3KTSyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:54:16 -0500
Date: Wed, 20 Nov 2013 13:54:13 -0500 (EST)
Message-Id: <20131120.135413.920731121262719289.davem@davemloft.net>
To: grundler@google.com
Cc: freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, davemloft@davemloft.net,
        louis@asix.com.tw, allan@asix.com.tw, daniel@asix.com.tw
Subject: Re: [PATCH 1/1] Workaround for Suspend/Resume issue of AX88772B
 under ChromeOS
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANEJEGtBmvFNcFzOW9ZnOFd=ZMnz82ajcN52YqW3+n0+=rhxBA@mail.gmail.com>
References: <1384913496-26261-1-git-send-email-freddy@asix.com.tw>
	<20131120.004026.2013972041095203460.davem@davemloft.net>
	<CANEJEGtBmvFNcFzOW9ZnOFd=ZMnz82ajcN52YqW3+n0+=rhxBA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Nov 2013 10:54:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@google.com>
Date: Wed, 20 Nov 2013 09:42:42 -0800

> While this patch raises a new issue, can you apply this patch anyway
> since in most cases (default settings) it improves "the user
> experience" for most users?

I'm not applying a patch which knowingly is not implemented correctly.

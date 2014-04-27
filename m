Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaD0SFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:05:25 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:43069 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaD0SFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:05:23 -0400
Message-ID: <1398621918.30622.6.camel@wisdom>
Subject: Re: [PATCH 2/2] staging/rtl8192e: userspace ptr deref + incorrect
 declarations
From: Dominique van den Broeck <domdevlin@free.fr>
Reply-To: domdevlin@free.fr
To: Levente Kurusa <levex@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 27 Apr 2014 20:05:18 +0200
In-Reply-To: <20140427174753.GA25594@linux.com>
References: <1398618676-31095-1-git-send-email-domdevlin@free.fr>
	 <1398618676-31095-2-git-send-email-domdevlin@free.fr>
	 <20140427174753.GA25594@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Thanks for your comments and reviewing.

> I guess it would be better to have defines for those instead of
> hard-coding the offsets. Also the size of the info_buf array
> might change depending on the size of wrqu->data.pointer, right?
> Maybe create a new define for that as well?
> Let's just be safe and create new defines to prevent headaches in
> the future, if not for futher expansion then for the sake of
> legibility.

As regards those hardcoded indexes, I totally agree.

Still, for this particular patch only, I tried to stick to what
was signaled by sparse. I kept the rest as it was. "info_buf",
directly pointing userspace, and its index numbers are declared
this way by the original code...

I remain totally willing to make it better. :-)

Cheers.




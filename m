Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaAURXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:23:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaAURXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:23:32 -0500
Date: Tue, 21 Jan 2014 09:24:14 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>
Subject: Re: [PATCH] serial: samsung: move clock deactivation below uart
 registration
Message-ID: <20140121172414.GB19595@kroah.com>
References: <201312050054.39327.heiko@sntech.de>
 <2813762.7GxfVBIcrq@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2813762.7GxfVBIcrq@phil>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:26:42PM +0100, Heiko Stübner wrote:
> Hi Greg,
> 
> just wanted to ask about the state of this patch. I can see it in your branch 
> named "fixes" [0] but it seems it hasn't made its way into the kernel neither 
> during the 3.13-rcs or with your 3.14-pull [1].
> 
> 
> Thanks
> Heiko
> 
> 
> [0] https://git.kernel.org/cgit/linux/kernel/git/gregkh/tty.git/log/?h=fixes
> [1] 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=bcee63488ece9a0fca8be19951428a7b41001e66

Ah crap, I missed this, sorry, I'll get it to Linus in time for
3.14-final, sorry about that.

greg k-h

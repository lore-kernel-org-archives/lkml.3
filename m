Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3HCD15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 23:27:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3HCD14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 23:27:56 -0400
Date: Sat, 3 Aug 2013 11:29:08 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yacine Belkadi <yacine.belkadi.1@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Thomas Renninger <trenn@suse.de>, Hannes Reinecke <hare@suse.de>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ming Lei <ming.lei@canonical.com>,
        =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Julius Werner <jwerner@chromium.org>,
        Yuanhan Liu <yliu.null@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] usb: fix some scripts/kernel-doc warnings
Message-ID: <20130803032908.GA10902@kroah.com>
References: <1375467004-2623-1-git-send-email-yacine.belkadi.1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375467004-2623-1-git-send-email-yacine.belkadi.1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 08:10:04PM +0200, Yacine Belkadi wrote:
> When building the htmldocs (in verbose mode), scripts/kernel-doc reports the
> following type of warnings:
> 
> Warning(drivers/usb/core/usb.c:76): No description found for return value of
> 'usb_find_alt_setting'
> 
> Fix them by:
> - adding some missing descriptions of return values
> - using "Return" sections for those descriptions
> 
> Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
> ---
> 
>  Applied to b3a3a9c441e2c8f6b6760de9331023a7906a4ac6

What does this line mean?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaJNHgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:36:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbaJNHga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:36:30 -0400
Date: Tue, 14 Oct 2014 09:35:25 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Shao <huishao@microsoft.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Subject: Re: [PATCH] hyperv: Implement Time Synchronization using host time
 sample
Message-ID: <20141014073525.GA3189@kroah.com>
References: <1413275026-5645-1-git-send-email-huishao@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413275026-5645-1-git-send-email-huishao@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 01:23:46AM -0700, Thomas Shao wrote:
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1786,6 +1786,7 @@ int do_adjtimex(struct timex *txc)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL(do_adjtimex);

EXPORT_SYMBOL_GPL()?

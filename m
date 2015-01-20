Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbbATWBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:01:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbbATWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:01:32 -0500
Date: Wed, 21 Jan 2015 06:01:23 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Rom Lemarchand <romlem@google.com>,
        Mark Salyzyn <salyzyn@google.com>, Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 2/2][RFC] staging: Remove the Android logger driver
Message-ID: <20150120220123.GA15097@kroah.com>
References: <1421790155-3309-1-git-send-email-john.stultz@linaro.org>
 <1421790155-3309-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421790155-3309-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 01:42:35PM -0800, John Stultz wrote:
> With the relase of Lollipop, Android no longer
> requires the logger driver.
> 
> There are three patches which the android dev's
> still need before they drop logger on all their
> devices:
> 
> [PATCH v3 1/3] pstore: use scnprintf
> [PATCH 2/3] pstore: remove superfluous memory size check
> [PATCH v2 3/3] pstore: add pmsg
> 
> But these seem to have been acked and are hopefully
> queued for upstream.

That's great news, are these pstore patches in linux-next already?  If
so, I'll be glad to queue this up for 3.20.

thanks,

greg k-h

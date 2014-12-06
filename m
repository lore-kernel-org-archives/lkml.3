Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaLFFHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:07:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLFFHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:07:36 -0500
Date: Fri, 5 Dec 2014 21:07:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Implement a clockevent device
Message-ID: <20141206050734.GA6562@kroah.com>
References: <1417838324-26378-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417838324-26378-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 07:58:44PM -0800, K. Y. Srinivasan wrote:
> Implement a clockevent device based on the timer support available on
> Hyper-V.
> In this version of the patch I have addressed Jason's review comments.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Jason Wang <jasowang@redhat.com>
> ---

Why did you resend the 1st version of this patch?

If you didn't send the first version, why is there no more "vX" on the
Subject line?

confused.

greg k-h

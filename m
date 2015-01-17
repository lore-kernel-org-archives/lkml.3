Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbbAQOGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 09:06:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbAQOGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 09:06:03 -0500
Date: Sat, 17 Jan 2015 06:05:59 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix Kernel Panic due to dereference of the invalid
 handle. First validate the handle and then derefer it in BUG_ON.
Message-ID: <20150117140559.GA26060@kroah.com>
References: <1421475161-17755-1-git-send-email-shailendra.capricorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421475161-17755-1-git-send-email-shailendra.capricorn@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 11:42:41AM +0530, Shailendra Verma wrote:
> 
> Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
> ---
>  drivers/staging/android/ion/ion.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Something went wrong with your subject line, please fix it up and
resend.

thanks,

greg k-h

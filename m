Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaCFT40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:56:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaCFT4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:56:25 -0500
Date: Thu, 6 Mar 2014 11:58:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, shaun@xresource.ca, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org, dulshani.gunawardhana89@gmail.com,
        ying.xue@windriver.com, davem@davemloft.net, dan.carpenter@oracle.com
Subject: Re: [PATCH v2 7/7] staging: cxt1e1: remove unneeded a value
Message-ID: <20140306195812.GE3403@kroah.com>
References: <6282871.ckfvQvsDb4@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6282871.ckfvQvsDb4@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 05:12:48PM +0900, Daeseok Youn wrote:
> 
> It doesn't need to assign name array address to np pointer.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> v2: replace sprintf() with snprintf() and remove memset() call
> because snprintf() adds a terminating '\0'

Your Subject: does not make sense, please fix it up and resend.

thanks,

greg k-h

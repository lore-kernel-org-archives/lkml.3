Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaHKIUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:20:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaHKIUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:20:52 -0400
Date: Mon, 11 Aug 2014 16:20:15 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: steve.glendinning@shawell.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc: replace WARN_ON() with WARN_ON_SMP()
Message-ID: <20140811082015.GA1422@kroah.com>
References: <1407744983-29289-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407744983-29289-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:46:23PM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration and therefore it
> would be advise to repalce with WARN_ON_SMP().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/net/ethernet/smsc/smsc911x.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hint, I have nothing to do with this file, no need to send a patch for
it to me, I can't do anything with it...

thanks,

greg k-h

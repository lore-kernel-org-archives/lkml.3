Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaHKFpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:45:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaHKFpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:45:43 -0400
Date: Mon, 11 Aug 2014 13:45:07 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Avinash kumar <avi.kp.137@gmail.com>
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: vt6655: wpactl.c  checkpatch clean-up
Message-ID: <20140811054507.GJ13727@kroah.com>
References: <1407693535-14309-1-git-send-email-avi.kp.137@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407693535-14309-1-git-send-email-avi.kp.137@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 11:28:55PM +0530, Avinash kumar wrote:
> Cleaned all C99 comments related warnings
> 
> Signed-off-by :Avinash Kumar <avi.kp.137@gmail.com>
> 
> Signed-off-by: Avinash kumar <avi.kp.137@gmail.com>

Why is this line twice in here, the first one has the ':' in the wrong
place.

Please resend with it the line only once in the changelog entry.

thanks,

greg k-h

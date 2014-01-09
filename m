Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaAISmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:42:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAISmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:42:43 -0500
Date: Thu, 9 Jan 2014 10:43:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <cyborg101010@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DAS1800: Fixed typeo.
Message-ID: <20140109184314.GB10563@kroah.com>
References: <1388682600-25443-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388682600-25443-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 05:10:00PM +0000, Joe Borg wrote:
> Fixed foo * bar should be foo *bar.
> 
> Fixed by Joe Borg root@josephb.org

That's not a "signed-off-by:" line, did you run this patch through
scripts/checkpatch.pl?

Also, your subject line has a typo :)

thanks,

greg k-h

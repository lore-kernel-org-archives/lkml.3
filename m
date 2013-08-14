Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab3HNRDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:03:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab3HNRDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:03:18 -0400
Date: Wed, 14 Aug 2013 10:04:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jack Hill <jackhill@jackhill.us>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [ 04/23] SCSI: qla2xxx: Properly set the tagging for commands.
Message-ID: <20130814170450.GB7668@kroah.com>
References: <20130802102036.180660415@linuxfoundation.org>
 <20130802102036.810716252@linuxfoundation.org>
 <alpine.DEB.2.02.1308141238220.31921@pilot.trilug.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308141238220.31921@pilot.trilug.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 12:40:56PM -0400, Jack Hill wrote:
> Hi Greg,
> 
> Apologies if this question is due to my ignorance of kernel development 
> practices. Feel free to point me at documentation.
> 
> I noticed that you applied this patch to the 3.10, 3.4, and 3.0 trees. On 
> kernel.org, it looks like 3.2 is also a longterm kernel. Why was this 
> patch not applied to that tree?

Possibly because the 3.2-stable maintainer hasn't picked it up yet?
It's a different developer, give him some time :)

thanks,

greg k-h

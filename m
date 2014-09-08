Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaIHRY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:24:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbaIHRYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:24:55 -0400
Date: Mon, 8 Sep 2014 10:24:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Kershner, David A" <David.Kershner@unisys.com>,
        *S-Par-Maintainer <SParMaintainer@unisys.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of
 context imbalance
Message-ID: <20140908172454.GA11205@kroah.com>
References: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E1@USEA-EXCH7.na.uis.unisys.com>
 <20140908170613.GB10454@kroah.com>
 <C97001BC43954D438ACB059713BA5CDFC97127E0E5@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDFC97127E0E5@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 12:10:55PM -0500, Romer, Benjamin M wrote:
> On Mon, 2014-09-08 at 10:06 -0700, Greg Kroah-Hartman wrote:
> > Traditionally, you would respond with a:
> > 	Acked-by: Developer Name <email@address>
> > so I can add it to the patch.
> > 
> > Care to do that here?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Of course. :)
> 
> Acked-by: Benjamin Romer <benjamin.romer@unisys.com>
> 
> Should I do this instead of Tested-by and Signed-off-by, in the future?

If you test it, do a tested-by.

If you sign off on it (i.e. it flows through you to me), then a
signed-off is correct.

Hope this helps,

greg k-h

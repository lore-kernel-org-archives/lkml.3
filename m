Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab3GZWBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:01:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZWBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:01:34 -0400
Date: Fri, 26 Jul 2013 15:01:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: devel@driverdev.osuosl.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] staging: xillybus: Multiple definition of xillyname
 resolved (bug fix)
Message-ID: <20130726220132.GA32106@kroah.com>
References: <1374873840-26015-1-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374873840-26015-1-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 12:24:00AM +0300, Eli Billauer wrote:
> 
> Signed-off-by: Eli Billauer <eli.billauer@gmail.com>

You forgot a "Reported-by:" line here, I'll go add it by hand, but
please do so yourself next time.

thanks,

greg k-h

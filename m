Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3IZPjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:39:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3IZPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:39:07 -0400
Date: Thu, 26 Sep 2013 08:39:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 0/3] mei: few more reset recursion fixes
Message-ID: <20130926153906.GA9267@kroah.com>
References: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 01:29:44PM +0300, Tomas Winkler wrote:
> *** BLURB HERE ***

I think you need to read your emails a bit better :)

> Alexander Usyskin (1):
>   mei: cancel stall timers in mei_reset
> 
> Tomas Winkler (2):
>   mei: make me client counters less error prone
>   mei: bus: stop wait for read during cl state transition

You tagged all of these for the stable tree, yet didn't ask for them to
be included in 3.12-final, which is a bit confusing.  If these are
really issues that people are hitting, don't you want these merged to
3.12-final?

thanks,

greg k-h

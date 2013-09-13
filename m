Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3IMMer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:34:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3IMMeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:34:46 -0400
Date: Fri, 13 Sep 2013 05:35:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [00/23] 3.4.62-stable review
Message-ID: <20130913123500.GC29683@kroah.com>
References: <20130912174451.748805761@linuxfoundation.org>
 <20130912174451.948344919@linuxfoundation.org>
 <20130913050437.GA25523@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913050437.GA25523@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:04:37PM -0700, Guenter Roeck wrote:
> Odd, the 00/23 mail for 3.4.62 doesn't show up on lkml.
> So this mail will most likely show up as reply to 01/23.
> 
> Anyway, here are my build results for 3.4.62:
> 	total: 103 pass: 89 skipped: 10 fail: 4
> 
> More configurations (added two crisv32 as well as several arm builds),
> one less failure (m32r:defconfig now builds).

That's looking better, thanks for testing and letting me know.

greg k-h

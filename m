Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab3GZOyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:54:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080Ab3GZOyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:54:54 -0400
Date: Fri, 26 Jul 2013 07:56:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?B=E1lint?= Czobor <czoborbalint@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: misc: Add support for ANDROID_PMEM
Message-ID: <20130726145608.GA27289@kroah.com>
References: <1374662321-27152-1-git-send-email-czoborbalint@gmail.com>
 <CAL6DFdeJFz2F5FP+0w44ygfATDkNQTBpV7ODkbBFwerq50H4Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL6DFdeJFz2F5FP+0w44ygfATDkNQTBpV7ODkbBFwerq50H4Rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 02:53:21PM +0200, Bálint Czobor wrote:
> Thank you for the info.
> However some devices still use it, sorry, I haven't seen that commit.

No modern Android devices should use pmem, only obsolete ones, right?
That's why the code was removed.

Do you have a device that requires this?

You also mixed in a lot of device-specific changes, do you need those to
be applied?  If so, please make up a separate patch and submit it.

thanks,

greg k-h

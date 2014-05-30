Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbaE3QNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:13:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaE3QNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:13:17 -0400
Date: Fri, 30 May 2014 09:13:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: =?utf-8?B?R8O8bMWfYWggS8O2c2U=?= <gulsah.1004@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, pali.rohar@gmail.com,
        Kristina =?utf-8?Q?Mart=C5=A1enko?= 
	<kristina.martsenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
Message-ID: <20140530161308.GA17822@kroah.com>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530160121.GB10682@kroah.com>
 <CAMGgR5tjjEXpyOyo8NwT+OSXqGhD1_6jk20AvJ8XAP-5p7z_kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGgR5tjjEXpyOyo8NwT+OSXqGhD1_6jk20AvJ8XAP-5p7z_kg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Fri, May 30, 2014 at 05:05:54PM +0100, Miguel Oliveira wrote:
> Greg should I make a patch for the whitespace while you are
> considering in remove the driver?

Yes, that would be fine, it will be another kernel release cycle before
I remove any more drivers.

thanks,

greg k-h

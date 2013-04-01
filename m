Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab3DADF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:05:58 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:46734 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3DADF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:05:57 -0400
Date: Sun, 31 Mar 2013 20:05:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: jhovold@gmail.com, Jiri Slaby <jslaby@suse.cz>, mferrell@uplogix.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/usb/serial: looping issue: return value may
 override by looping
Message-ID: <20130401030555.GA21113@kroah.com>
References: <5158F689.5040406@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5158F689.5040406@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 10:52:57AM +0800, Chen Gang wrote:
> Hello Maintainers:
> 
> in drivers/usb/serial/mos7840.c:
> 
>   in 'for' looping (line 632..657)
>     the return value 'rv' may override if not have a check in time (line 654)
> 
>   next checking can not find failure which generated during looping (line 658)
> 
>   please help check, thanks.

No.  Please send real patches if you think something is wrong, after
determining something is incorrect.  To waste people's time like this,
checking to see if you have misunderstood something, does not scale at
all, please be more considerate.

greg k-h

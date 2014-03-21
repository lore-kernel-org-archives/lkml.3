Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbaCUQMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:12:32 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55304 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaCUQMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:12:30 -0400
Date: Fri, 21 Mar 2014 09:11:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch on Kconfig files
Message-ID: <20140321161111.GA18068@roeck-us.net>
References: <20140321094239.18aebf02@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321094239.18aebf02@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 09:42:39AM +0100, Jean Delvare wrote:
> Hi Andy, hi Joe,
> 
> When running checkpatch on a patch which tweaks many Kconfig entries, I
> got the following output:
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #74: FILE: drivers/hid/Kconfig:142:
>  config HID_BELKIN
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #82: FILE: drivers/hid/Kconfig:149:
>  config HID_CHERRY
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #135: FILE: drivers/hid/Kconfig:415:
>  config HID_MICROSOFT
> 
> total: 0 errors, 3 warnings, 88 lines checked
> 
> I am not adding these entries, just tweaking the dependencies. Thus I
> don't think it makes sense to print these warnings, they aren't
> relevant to the changes I am making. There comment in checkpatch says:
> 
> # check for Kconfig help text having a real description
> # Only applies when adding the entry originally, after that we do not have
> # sufficient context to determine whether it is indeed long enough.
> 
> So I suspect these warnings aren't supposed to be displayed. I recall
> hitting this many times in the past, in fact I think this is the most
> frequent and oldest false positive I get from checkpatch. So I would
> appreciate if this could be fixed, either by really limiting the
> warning to Kconfig entries being added (if you can) or by dropping the
> check altogether (if you can't.)
> 
For my part this is the one and only checkpatch warning which I don't
enfore and happily ignore myself. Might be interesting to get feedback
from others if they think it is useful or just annoying.

Guenter

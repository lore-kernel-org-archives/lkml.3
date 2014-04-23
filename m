Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaDXA37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:29:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaDXA3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:29:50 -0400
Date: Wed, 23 Apr 2014 16:45:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] sysfs, device-tree: aid for debugging device tree boot
 problems
Message-ID: <20140423234501.GA17827@kroah.com>
References: <53571685.5060403@gmail.com>
 <20140423032044.GA26233@kroah.com>
 <53584277.7000405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53584277.7000405@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 03:45:11PM -0700, Frank Rowand wrote:
> >>   3) To find list of device tree nodes with a bound driver:
> >>
> >>   # output is:  driver_name node_full_path
> >>   #
> >>   cd /proc/device-tree
> >>   for k in `find . -name %driver_name` ; do
> >>      echo `cat ${k}` `echo ${k} | sed -e 's|./||' -e 's|/%driver_name$||'`
> >>   done | sort
> > 
> > If we take this patch, these examples should be somewhere in the
> > documentation to make it easy for others.
> 
> That is a good idea.  I'll package up the equivalent shell code from
> Grant's email.  Any suggestions on location?
> 
>   scripts/debug/devicetree/
>   scripts/devicetree/debug/
>   Documentation/devicetree/scripts/

tools/ is probably the best place for them, or in Documentation/, either
would work.

thanks,

greg k-h

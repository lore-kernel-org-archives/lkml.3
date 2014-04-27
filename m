Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaD0K1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 06:27:51 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46021 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaD0K1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 06:27:49 -0400
Date: Sun, 27 Apr 2014 12:27:19 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Xiao Jin <jin.xiao@intel.com>
Cc: Johan Hovold <jhovold@gmail.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        juan.zou@intel.com, yanmin.zhang@intel.com,
        david.a.cohen@linux.intel.com, "Zhang, Qi1" <qi1.zhang@intel.com>
Subject: Re: [PATCH] usb_wwan: some improvement on write and resume
Message-ID: <20140427102719.GJ2206@localhost>
References: <1398387435-13829-1-git-send-email-jin.xiao@intel.com>
 <20140425091959.GC2206@localhost>
 <535C6851.9050506@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535C6851.9050506@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 10:15:45AM +0800, Xiao Jin wrote:
> > They are however two distinct bugs and should be fixed separately. Could
> > you split the fixes into two patches and resubmit?
> >
> > Please also include a more descriptive subject line for each patch, for
> > example:
> >
> > 	"USB: usb_wwan: fix urb leak in write error path"
> > 	"USB: usb_wwan: fix race between write and resume"
> >
> > You should probably point out that the write-resume race could also lead
> > to writes being reordered in the description of that patch.
> >
> 
> Thanks. I will resubmit two patches.

Thanks for resending. I'll include them in the autosuspend series I'll
hopefully be able to post shortly.

Johan

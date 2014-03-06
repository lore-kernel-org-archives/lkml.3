Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaCFTxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:53:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaCFTxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:53:41 -0500
Date: Thu, 6 Mar 2014 11:55:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Valentina Manea <valentina@rosedu.org>
Cc: "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        devel@driverdev.osuosl.org, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, tobias.polzer@fau.de, dominik.paulus@fau.de,
        ihadzic@research.bell-labs.com
Subject: Re: [firefly] [PATCH 06/12] staging: usbip: userspace: add new list
 API
Message-ID: <20140306195527.GC3403@kroah.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
 <1393960252-21247-7-git-send-email-valentina.manea.m@gmail.com>
 <20140305063539.GB8816@kroah.com>
 <20140305101603.GX27552@mwanda>
 <CAByK=5bzS4R0sGj5w5x8gc8DcKXvnr58WskoShuq6G30YTsOgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAByK=5bzS4R0sGj5w5x8gc8DcKXvnr58WskoShuq6G30YTsOgQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 07:45:27AM +0200, Valentina Manea wrote:
> 
> 
> 
> On Wed, Mar 5, 2014 at 12:16 PM, Dan Carpenter <dan.carpenter@oracle.com>
> wrote:
> 
>     On Tue, Mar 04, 2014 at 10:35:39PM -0800, Greg KH wrote:
>     > On Tue, Mar 04, 2014 at 09:10:46PM +0200, Valentina Manea wrote:
>     > > Add a new list API from CCAN.
>     >
>     > Why can't you just take the one from the kernel, as userspace is GPLv2
>     > code, right?
>     >
>     > And are you sure CC0 is a "valid" license that you can mix with GPLv2
>     > code?  I ask this seriously, as I have heard that CC0 really isn't even
>     > a valid license at all, and if I was to accept this patch, I'm going to
>     > have to go talk to some lawyers, which isn't going to be fun...
>     >
> 
>     GNU people say it's compitable.
>     https://www.gnu.org/licenses/license-list.html#CC0
> 
>     It's not a good license because it doesn't say anything about that there
>     is no warranties.  Maybe other reasons as well.
> 
>     regards,
>     dan carpenter
> 
> 
> 
> As Dan pointed out, it seems that CC0 is compatible with GPLv2.
> However, if needed, I can change the lists API.

You only need the list.h file from the kernel source, strip it down to
just the functions you actually use, and then you should be fine.  Much
smaller codebase to worry about as well, which is always good.

Just be explicit where you copied the file from.

thanks,

greg k-h

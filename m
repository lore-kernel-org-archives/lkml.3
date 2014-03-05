Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaCEKRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:17:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40529 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaCEKRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:17:14 -0500
Date: Wed, 5 Mar 2014 13:16:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Valentina Manea <valentina.manea.m@gmail.com>, devel@driverdev.osuosl.org,
        shuah.kh@samsung.com, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org, firefly@lists.rosedu.org,
        dominik.paulus@fau.de, ihadzic@research.bell-labs.com
Subject: Re: [PATCH 06/12] staging: usbip: userspace: add new list API
Message-ID: <20140305101603.GX27552@mwanda>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
 <1393960252-21247-7-git-send-email-valentina.manea.m@gmail.com>
 <20140305063539.GB8816@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305063539.GB8816@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 10:35:39PM -0800, Greg KH wrote:
> On Tue, Mar 04, 2014 at 09:10:46PM +0200, Valentina Manea wrote:
> > Add a new list API from CCAN.
> 
> Why can't you just take the one from the kernel, as userspace is GPLv2
> code, right?
> 
> And are you sure CC0 is a "valid" license that you can mix with GPLv2
> code?  I ask this seriously, as I have heard that CC0 really isn't even
> a valid license at all, and if I was to accept this patch, I'm going to
> have to go talk to some lawyers, which isn't going to be fun...
> 

GNU people say it's compitable.
https://www.gnu.org/licenses/license-list.html#CC0

It's not a good license because it doesn't say anything about that there
is no warranties.  Maybe other reasons as well.

regards,
dan carpenter

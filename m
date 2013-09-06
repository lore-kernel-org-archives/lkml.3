Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750771Ab3IFE7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:59:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3IFE7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:59:13 -0400
Date: Thu, 5 Sep 2013 22:01:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH RESEND v3 3/7] Intel MIC Host Driver, card OS state
 management.
Message-ID: <20130906050157.GF28806@kroah.com>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
 <669a3a3bbfff577c73d05fb568a810cbbc3d5333.1378423596.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <669a3a3bbfff577c73d05fb568a810cbbc3d5333.1378423596.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 04:41:55PM -0700, Sudeep Dutt wrote:
> +What:		/sys/class/mic/mic(x)/firmware
> +Date:		August 2013
> +KernelVersion:	3.11
> +Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
> +Description:
> +		When read, this sysfs entry provides the path name under
> +		/lib/firmware/ where the firmware image to be booted on the
> +		card can be found. The entry can be written to change the
> +		firmware image location under /lib/firmware/.

I don't understand, is the path under the HOST device, or the Client
device's disk?  Why do you need to change the path on the HOST?  What's
wrong with the existing firmware path selection we have in the kernel?

thanks,

greg k-h

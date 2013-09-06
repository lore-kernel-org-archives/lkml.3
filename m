Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750817Ab3IFE5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:57:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3IFE5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:57:53 -0400
Date: Thu, 5 Sep 2013 22:00:37 -0700
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
Message-ID: <20130906050037.GE28806@kroah.com>
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
> +What:		/sys/class/mic/mic(x)/cmdline
> +Date:		August 2013
> +KernelVersion:	3.11
> +Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
> +Description:
> +		An Intel MIC device runs a Linux OS during its operation. Before
> +		booting this card OS, it is possible to pass kernel command line
> +		options to configure various features in it, similar to
> +		self-bootable machines. When read, this entry provides
> +		information about the current kernel command line options set to
> +		boot the card OS. This entry can be written to change the
> +		existing kernel command line options. Typically, the user would
> +		want to read the current command line options, append new ones
> +		or modify existing ones and then write the whole kernel command
> +		line back to this entry.

Is a PAGE_SIZE value going to be big enough for your command line?  I
know some embedded systems have horribly long command lines, hopefully
this will be enough for you.

thanks,

greg k-h

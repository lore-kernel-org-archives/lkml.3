Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3IZUyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:54:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3IZUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:53:59 -0400
Date: Thu, 26 Sep 2013 13:53:58 -0700
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
Subject: Re: [PATCH RESEND v3 0/7] Enable Drivers for Intel MIC X100
 Coprocessors.
Message-ID: <20130926205358.GA19455@kroah.com>
References: <cover.1378423596.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378423596.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 04:41:20PM -0700, Sudeep Dutt wrote:
> ChangeLog:
> =========
> 
> v2 => v3:
> a) Patch 1 data structure cleanups, header file include cleanups,
>    IDA interface reuse and switching to device_create_with_groups(..)
>    as per feedback from Greg Kroah-Hartman.
> b) Patch 7 signal documentation, sleep workaround removal and sysfs
>    access API cleanups as per feedback from Michael S. Tsirkin.

Now applied, thanks.

Note, I'm getting some odd warnings about the uapi .h files when doing a
build, so a follow-on patch to fix those up would be appreciated, along
with the other minor cleanups I discussed with you previously.

thanks,

greg k-h

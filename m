Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3I0DRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:17:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3I0DQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:16:55 -0400
Date: Thu, 26 Sep 2013 20:16:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH CHAR-MISC-NEXT 2/4] Intel MIC Driver Header File Cleanups.
Message-ID: <20130927031654.GB13086@kroah.com>
References: <cover.1380241770.git.sudeep.dutt@intel.com>
 <1db9ec1d28297b01c01f0f4089cb5ce559906ac8.1380241770.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1db9ec1d28297b01c01f0f4089cb5ce559906ac8.1380241770.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 06:10:01PM -0700, Sudeep Dutt wrote:
> Dont use same name for header files in different folders.
> 
> These changes were suggested by Greg Kroah-Hartman during the
> code review @ https://lkml.org/lkml/2013/9/6/18
> 
> Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
> Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
> Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
> Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
> ---
>  drivers/misc/mic/card/mic_debugfs.c  |  2 +-
>  drivers/misc/mic/card/mic_device.c   |  2 +-
>  drivers/misc/mic/card/mic_virtio.c   |  2 +-
>  drivers/misc/mic/card/mic_x100.c     |  2 +-
>  drivers/misc/mic/common/mic_dev.h    | 51 ++++++++++++++++++++++++++++++++++++
>  drivers/misc/mic/common/mic_device.h | 51 ------------------------------------
>  drivers/misc/mic/host/mic_boot.c     |  2 +-
>  drivers/misc/mic/host/mic_debugfs.c  |  2 +-
>  drivers/misc/mic/host/mic_fops.c     |  2 +-
>  drivers/misc/mic/host/mic_intr.c     |  2 +-
>  drivers/misc/mic/host/mic_main.c     |  2 +-
>  drivers/misc/mic/host/mic_smpt.c     |  2 +-
>  drivers/misc/mic/host/mic_sysfs.c    |  2 +-
>  drivers/misc/mic/host/mic_virtio.c   |  2 +-
>  drivers/misc/mic/host/mic_x100.c     |  2 +-
>  15 files changed, 64 insertions(+), 64 deletions(-)
>  create mode 100644 drivers/misc/mic/common/mic_dev.h
>  delete mode 100644 drivers/misc/mic/common/mic_device.h

git should have shown this file being renamed, not added/removed.
Please use the -M option to it when generating patches so it will do the
right thing here.

thanks,

greg k-h

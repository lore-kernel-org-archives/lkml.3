Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaK0DHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:07:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaK0DHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:07:18 -0500
Date: Wed, 26 Nov 2014 19:05:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 3/3] mei: add ABI documentation for fw_status
 exported through sysfs
Message-ID: <20141127030557.GC8656@kroah.com>
References: <1416409300-14431-1-git-send-email-tomas.winkler@intel.com>
 <1416409300-14431-3-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416409300-14431-3-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:01:40PM +0200, Tomas Winkler wrote:
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-class-mei | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-mei b/Documentation/ABI/testing/sysfs-class-mei
> index 0ec8b8178c41..61d45f03e09b 100644
> --- a/Documentation/ABI/testing/sysfs-class-mei
> +++ b/Documentation/ABI/testing/sysfs-class-mei
> @@ -14,3 +14,11 @@ Description:
>  		The /sys/class/mei/meiN directory is created for
>  		each probed mei device
>  
> +What:		/sys/class/mei/meiN/fw_status
> +Date:		Nov 2014
> +KernelVersion:	3.19
> +Contact:	Tomas Winkler <tomas.winkler@intel.com>
> +Description:	Display fw status registers content for applications
> +		that monitor fw health. The registers meaning is platform
> +		dependent.

That's not documenting what is in the file, "platform dependent" is
lame.

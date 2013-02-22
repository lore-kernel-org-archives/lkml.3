Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab3BVRRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:17:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:55087 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093Ab3BVRRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:17:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,717,1355126400"; 
   d="scan'208";a="260331358"
Message-ID: <5127A836.2020105@intel.com>
Date: Sat, 23 Feb 2013 01:17:42 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lan Tianyu <lantianyu1986@gmail.com>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
References: <20130221184010.GA24692@kroah.com> <20130222085954.GA4352@redhat.com> <51273F8E.3020807@intel.com> <20130222164318.GA27619@redhat.com> <5127A493.8040900@intel.com> <20130222171424.GC27619@redhat.com>
In-Reply-To: <20130222171424.GC27619@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/23 1:14, Dave Jones wrote:
> On Sat, Feb 23, 2013 at 01:02:11AM +0800, Lan Tianyu wrote:
>
>   > >   > > What can I do to debug this ?
>   > >   > 	Can you attach the output of dmesg with CONFIG_USB_DEBUG?
>   > >
>   > > http://paste.fedoraproject.org/3620
>   > How about"sudo lsusb -s 1:1 -v" or "2:1"?
>
> (12:13:51:davej@t430s:~)$ sudo lsusb -s 1:1
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> (12:13:53:davej@t430s:~)$ sudo lsusb -s 2:1
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>
Oh. Sorry, I didn't say clearly.
Please run
"sudo lsusb -s 1:1 -v"
"sudo lsusb -s 2:1 -v"

-- 
Best Regards
Tianyu Lan
linux kernel enabling team

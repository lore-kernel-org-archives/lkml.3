Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab3BVRVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:21:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab3BVRVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:21:02 -0500
Date: Fri, 22 Feb 2013 12:20:53 -0500
From: Dave Jones <davej@redhat.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lan Tianyu <lantianyu1986@gmail.com>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130222172053.GD27619@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Lan Tianyu <tianyu.lan@intel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	Lan Tianyu <lantianyu1986@gmail.com>
References: <20130221184010.GA24692@kroah.com>
 <20130222085954.GA4352@redhat.com>
 <51273F8E.3020807@intel.com>
 <20130222164318.GA27619@redhat.com>
 <5127A493.8040900@intel.com>
 <20130222171424.GC27619@redhat.com>
 <5127A836.2020105@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5127A836.2020105@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 01:17:42AM +0800, Lan Tianyu wrote:
 > On 2013/2/23 1:14, Dave Jones wrote:
 > > On Sat, Feb 23, 2013 at 01:02:11AM +0800, Lan Tianyu wrote:
 > >
 > >   > >   > > What can I do to debug this ?
 > >   > >   > 	Can you attach the output of dmesg with CONFIG_USB_DEBUG?
 > >   > >
 > >   > > http://paste.fedoraproject.org/3620
 > >   > How about"sudo lsusb -s 1:1 -v" or "2:1"?
 > >
 > > (12:13:51:davej@t430s:~)$ sudo lsusb -s 1:1
 > > Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
 > > (12:13:53:davej@t430s:~)$ sudo lsusb -s 2:1
 > > Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
 > >
 > Oh. Sorry, I didn't say clearly.
 > Please run
 > "sudo lsusb -s 1:1 -v"
 > "sudo lsusb -s 2:1 -v"

(12:20:00:davej@t430s:~)$ sudo lsusb -s 1:1 -v | fpaste
Uploading (2.3KiB)...
http://paste.fedoraproject.org/3623
(12:20:11:davej@t430s:~)$ sudo lsusb -s 2:1 -v | fpaste
Uploading (2.3KiB)...
http://paste.fedoraproject.org/3624



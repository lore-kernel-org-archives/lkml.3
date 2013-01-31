Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab3AaXWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:22:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45739 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab3AaXWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:22:20 -0500
Message-ID: <510AFCA1.5000700@zytor.com>
Date: Thu, 31 Jan 2013 15:22:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: William Hubbs <w.d.hubbs@gmail.com>
CC: linux-kernel@vger.kernel.org, mpagano@gentoo.org
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
In-Reply-To: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 02:51 PM, William Hubbs wrote:
> On a system that does not use an initramfs, /dev/root was always
> listed in /proc/mounts. This breaks software which scans /proc/mounts to
> determine which file systems are mounted since /dev/root is not a valid
> device name.
> 
> This changes that processing so that "/dev/root" is only added to
> /proc/mounts if a root device is not specified with the root= option on
> the kernel command line.
> 
> Signed-off-by: William Hubbs <w.d.hubbs@gmail.com>

Let me also point out that most of the time, the kernel actually has a
udev device name for an actual device...

	-hpa



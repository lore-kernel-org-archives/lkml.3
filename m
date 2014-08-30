Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaH3UlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:41:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3UlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:41:10 -0400
Date: Sat, 30 Aug 2014 13:41:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 3/4] staging: rtl8188eu: osdep_intf.h and usb_intf.c
Message-ID: <20140830204109.GC16168@kroah.com>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
 <1408703617-32248-1-git-send-email-cmroliv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408703617-32248-1-git-send-email-cmroliv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 11:33:37AM +0100, Miguel Oliveira wrote:
> Convert all rtw_proc_xxx references to rtw_sys_xxx in files
> include/osdep_intf.h and os_dep/usb_intf.c

Same comments as the previous ones, please redo all of these patches.

greg k-h

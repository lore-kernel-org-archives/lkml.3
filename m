Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3KHAZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:25:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab3KHAZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:25:00 -0500
Date: Thu, 7 Nov 2013 19:24:51 -0500
From: Dave Jones <davej@redhat.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-usb@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: usb-serial lockdep trace in linus' current tree.
Message-ID: <20131108002451.GA28672@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20131107223728.GA18157@redhat.com>
 <20131108000903.GD8555@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108000903.GD8555@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 01:09:03AM +0100, Johan Hovold wrote:
 
 > A recent change in usb-serial used the wrong memory-allocation flag in
 > write(), which results in a
 > 
 > 	[    5.979005] BUG: sleeping function called from invalid context at /home/johan/src/linux/linux-nu/mm/dmapool.c:310
 > 
 > with usb-next when using a usb-serial console as you seem to do be doing
 > as well.
 > 
 > Could be related. Care to give the fix below a try?

Seems to work. Feel free to add

Tested-by: Dave Jones <davej@fedoraproject.org>

if this is the agreed upon fix for this.

thanks,

	Dave


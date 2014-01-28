Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaA1EsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 23:48:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbaA1EsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 23:48:09 -0500
Date: Mon, 27 Jan 2014 23:47:49 -0500
From: Dave Jones <davej@redhat.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-ID: <20140128044749.GA27164@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tang Chen <tangchen@cn.fujitsu.com>,
	David Rientjes <rientjes@google.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1401271631090.17114@chino.kir.corp.google.com>
 <52E70165.8070709@cn.fujitsu.com>
 <20140128025537.GA21730@redhat.com>
 <52E722F5.9010505@cn.fujitsu.com>
 <20140128035518.GA25386@redhat.com>
 <52E7364F.5010700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E7364F.5010700@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:47:11PM +0800, Tang Chen wrote:
 > On 01/28/2014 11:55 AM, Dave Jones wrote:
 > > On Tue, Jan 28, 2014 at 11:24:37AM +0800, Tang Chen wrote:
 > >
 > >   >  >  I did a bisect with the patch above applied each step of the way.
 > >   >  >  This time I got a plausible looking result....
 > >   >
 > >   >  I cannot reproduce this. Would you please share how to reproduce it ?
 > >   >  Or does it just happen during the booting ?
 > >
 > > Just during boot. Very early. So early in fact, I have no logging facilities
 > > like usb-serial, just what is on vga console.
 > >
 > > If you want me to add some printk's, I can add a while (1); before
 > > the part that oopses so we can diagnose further..
 > 
 > Sure. Would you please do that for me ? Maybe we can find something in 
 > the early log.

I was hoping you'd have suggestions what you'd like me to dump ;-)

	Dave


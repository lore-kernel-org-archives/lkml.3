Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3CEXIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:08:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3CEXIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:08:48 -0500
Date: Tue, 5 Mar 2013 15:08:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>, Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 5/5] Kconfig: Make x86 and arm kernels default
 to the LZ4-compressed
Message-Id: <20130305150845.0d19a2875d39dac5d03b4b62@linux-foundation.org>
In-Reply-To: <5135DF44.2040806@openwrt.org>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
	<1362484056-9778-6-git-send-email-kyungsik.lee@lge.com>
	<5135DF44.2040806@openwrt.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Mar 2013 13:04:20 +0100 Florian Fainelli <florian@openwrt.org> wrote:

> Hello,
> 
> On 03/05/2013 12:47 PM, Kyungsik Lee wrote:
> > This patch makes x86 and arm kernels default to the LZ4-compressed
> > to test new LZ4 code in the linux-next. This is requested by
> > Andrew Morton.
> 
> I do not think making this the default is good idea, because the lz4demo 
> utility that you need to actually compress the kernel (used in patch 2) 
> is not installed nor available by default on most systems, while gzip 
> is.

Yes, that's a showstopper even for linux-next.  What a shame.

It means this code will walk into mainline with practically zero
third-party testing.  Oh well, the risk is minor.  If it breaks, people
can switch back to gzip easily enough.



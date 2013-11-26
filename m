Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3KZAqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:46:22 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:40657 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3KZAqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:46:10 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.97.166]
In-Reply-To: <20131125194256.GC28642@pengutronix.de>
References: <1385393160.4753.4.camel@phoenix>
	<20131125194256.GC28642@pengutronix.de>
Date: Tue, 26 Nov 2013 08:46:09 +0800
Message-ID: <CAFRkauD4ottp=O5AwkKM+mf8JJL3c7m-MUu1AmpKLtQ5ucah6g@mail.gmail.com>
Subject: Re: ARM: nommu: Boot hang after VFS: Mounted root (ext2 filesystem)
 on device 1:0.
From: Axel Lin <axel.lin@ingics.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jan Kara <jack@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/26 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hello,
>
> On Mon, Nov 25, 2013 at 11:26:00PM +0800, Axel Lin wrote:
>> I got hangup at boot after "VFS: Mounted root (ext2 filesystem) on device 1:0.".
>> I'm using ext2 initrd as root.
> which mainline version are you using? I don't know your problem, and I'm
> not using ext2 on my nommu target. So the only thing I can offer you is
> testing the same version.

Hi Uwe,
My patches for this SoC is on top of current Linus' tree.
I have devtmpfs enabled:
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y

Thanks,
Axel

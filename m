Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988AbaH0OiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:38:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53126 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934726AbaH0OiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:38:13 -0400
Date: Wed, 27 Aug 2014 10:38:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gavin Guo <gavin.guo@canonical.com>
cc: linux-usb@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>, YK <yk@canonical.com>
Subject: Re: About the reboot hang issue with EHCI driver on the Baytrail
 platform
In-Reply-To: <CA+eFSM25V2_kKT7EBfPmahTknQu3jMS3+4PC_Af6C+1eHrFhWg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1408271035351.1460-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Gavin Guo wrote:

> > Still, why not use the BIOS setting to disable EHCI?
> 
> It's hardware enablement policy. By default, we can't change the BIOS
> setting to make the bug disappear until we find out the bug is due to
> BIOS's bug. Add kernel parameters is the temporary solution for the
> platform can ship. And if the bug is from kernel, we need to send
> patches to upstream and pull back to Ubuntu kernel or send to Ubuntu
> Kernel directly if it's a trivial solution like adding device id.
> However, as you said, in this case about the bug the root may be from
> BIOS code. So, we can coordinate with the OEM BIOS team to modify the
> default BIOS setting.

There is no doubt that the BIOS is buggy.  Your log contains this line:

[    2.804205] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001

The only way that can happen is if the BIOS isn't working right. 
However, this may be a different bug from the crashes you've been 
seeing.

Alan Stern


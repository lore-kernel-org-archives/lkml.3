Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbaH0VEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:04:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199AbaH0VEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:04:05 -0400
Date: Wed, 27 Aug 2014 14:04:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci/pci-sysfs: Set pci interface in uppercase
Message-ID: <20140827210405.GA26372@kroah.com>
References: <1409144277-23379-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140827202301.GA13800@kroah.com>
 <20140827205129.GA25227@kroah.com>
 <CAPybu_2p0UroO=WwUOC3LybPq0HQymoD50v6-6gA+aVweveOHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_2p0UroO=WwUOC3LybPq0HQymoD50v6-6gA+aVweveOHw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 10:56:57PM +0200, Ricardo Ribalda Delgado wrote:
> No worries,
> 
> I have to mark for stable it or Bjorn? It it is me, how :) ?

Bjorn can when he applies it, for details on the process, see the kernel
file Documentation/stable_kernel_rules.txt

> ps: For other people reading this thread, the kmod/modprobe is in
> http://anonscm.debian.org/cgit/users/md/kmod.git/tree/libkmod/libkmod-index.c
> and handles all the modalias as strings without differing the type.

That sounds wrong, and odds are, will cause more problems over time.
These are hex values, not strings :(

thanks,

greg k-h

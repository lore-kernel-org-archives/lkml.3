Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3AQTmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:42:37 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33871 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3AQTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:42:36 -0500
Date: Thu, 17 Jan 2013 11:42:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 00/28] Drivers: hv: Update the Vmbus protocol
Message-ID: <20130117194232.GA3427@kroah.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354373160-31332-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 06:46:00AM -0800, K. Y. Srinivasan wrote:
> The current vmbus protocol supported in the vmbus driver for Linux is
> a version of the protocol that shipped with Windows Server 2008. Since
> then a lot of enhancements have been made in the protocol to
> specifically address performance and scalability of the communication
> infrastructure between the host and the guest.
> This patch-set brings our driver to the Win8 (Windows Server 2012) level.
> Furthermore, this code will dynamically negotiate the most efficient
> protocol that the host can support - the same code can be deployed on all
> supported hosts (WS2008, WS2008R2 and WS2012).
> Following are some of the key features implemented in this patch-set:
> 	
> 	1. More efficient signaling protocol between the host and the guest
> 	2. Distribution of interrupt load across available CPUs in the guest;
> 	   currently all vmbus interrupts are delivered to the boot CPU (CPU 0)
> 	   in the guest.
> 	3. Per- channel interrupt binding (as part of item 2)
> 	4. More efficient demultiplexing of incoming interrupts
> 	5. Per-channel signaling mechanism for host to guest communication

Nice work, all now applied.

greg k-h

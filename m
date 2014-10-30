Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbaJ3Quq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:50:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbaJ3Qup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:50:45 -0400
Date: Thu, 30 Oct 2014 17:50:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Bjorn Helgaas <bhelgaas@google.com>, Jeff Epler <jepler@unpythonic.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: fix name of 'enable' sysfs file
In-Reply-To: <20141030163028.GA22250@kroah.com>
Message-ID: <alpine.LRH.2.00.1410301749560.11562@twin.jikos.cz>
References: <20141030163028.GA22250@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Greg Kroah-Hartman wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Back in commit 5136b2da770d ("PCI: convert bus code to use dev_groups"),
> I misstyped the 'enable' sysfs file as 'enabled', which broke the
> userspace api.  This patch fixes that issue by renaming the file back.

But this is in turn 3.13 -> 3.18 userspace interface breakage ... I don't 
think there is other graceful way out of this than creating a symlink so 
that both variants work, right?

-- 
Jiri Kosina
SUSE Labs


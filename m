Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3JVFoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 01:44:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3JVFoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 01:44:15 -0400
Date: Tue, 22 Oct 2013 06:45:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/misc: add rawio framework driver
Message-ID: <20131022054538.GB14163@kroah.com>
References: <5265C0C8.10609@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5265C0C8.10609@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:03:20PM -0700, Bin Gao wrote:
> Rawio provides a framework to read/write registers from a bus, including
> pci, i2c, I/O device(memory mapped), etc. based on debug fs.
> Rawio bus drivers implement the read/write operation on a specific bus
> on top of the rawio framework driver.
> They are designed to help device driver and kernel debugging on
> embedded systems.

Oh, one more technical thing, you totally fail to document the
user/kernel api you have just created.  You are parsing userspace data
in ways that I really don't understand at all...

greg k-h

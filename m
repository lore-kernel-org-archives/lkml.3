Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403Ab3GSCF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:05:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933633Ab3GSCFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:05:55 -0400
Date: Thu, 18 Jul 2013 19:06:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: daniel.kiper@oracle.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Eric Biederman <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Brandon Philips <brandon@ifup.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: is kexec on Xen domU possible?
Message-ID: <20130719020603.GA22932@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was messing around with kexec and it seems to work just fine on KVM,
but for Xen domU images, it doesn't work at all.  Daniel, I saw some
patches from you back in September 2012 for adding this support for
Dom0, but they don't seem to have gone into the kernel (but other
patches went into kexec-tools at that time.)  You mention that domU
support is "easy" after your patches go in, is that because Dom0 needs
to support this, or is it something specific to only domU?

Also, what's the status of those patches for the kernel, I don't see
them reposted anywhere, did you drop them?

thanks,

greg k-h

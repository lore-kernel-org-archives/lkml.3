Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaIYKqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:46:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIYKqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:46:08 -0400
Date: Thu, 25 Sep 2014 12:45:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-kernel@vger.kernel.org, naushad@samsung.com
Subject: Re: [PATCH] kobject: fix NULL pointer derefernce in kobj_child_ns_ops
Message-ID: <20140925104512.GC28590@kroah.com>
References: <1411556154-14464-1-git-send-email-pankaj.dubey@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411556154-14464-1-git-send-email-pankaj.dubey@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 04:25:54PM +0530, Pankaj Dubey wrote:
> We will hit NULL pointer dereference if we call
> platform_device_register_simple or platform_device_add at very early
> stage. I have observed following crash when called platform_device_add
> from "init_irq" hook of machine_desc. This patch fixes this issue and
> let system handle this case gracefully instead of kernel panic.

Is there any in-tree code that needs this "fix"?  Or can it wait for
3.18?

thanks,

greg k-h

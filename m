Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaBSUva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:51:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:47126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbaBSUv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:51:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,507,1389772800"; 
   d="scan'208";a="342169257"
Message-ID: <1392843083.11798.74.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH] drivers/tty/serial: deal with 8250_core.c uninitialized
 warning for good
From: Alan Cox <alan@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Feb 2014 20:51:23 +0000
In-Reply-To: <1392840013-15957-1-git-send-email-paul.gortmaker@windriver.com>
References: <1392840013-15957-1-git-send-email-paul.gortmaker@windriver.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 15:00 -0500, Paul Gortmaker wrote:
> Every couple of months, someone sends a patch to fix:
> 
> drivers/tty/serial/8250/8250_core.c: In function 'serial_unlink_irq_chain':
> drivers/tty/serial/8250/8250_core.c:1712:2: warning: 'i' may be used uninitialized in this function [-Wuninitialized]
> 
> and they in turn get a NACK for their efforts, and are told that
> their compiler is broken.  This has been going on since at least
> the year 2008:  https://lkml.org/lkml/2008/11/24/433
> 
> Lets add a comment, so that subsequent patches don't get as far as
> the maintainers or the mailing lists.

Are people still using gcc variants that get this wrong ?

Fine by me.

Acked-by: Alan Cox <alan@linux.intel.com>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbaGXWC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:02:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXWCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:02:55 -0400
Date: Thu, 24 Jul 2014 15:02:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/1 linux-next] staging: ion: vm_insert_pfn and
 zap_page_range rely on CONFIG_MMU
Message-ID: <20140724220254.GA26815@kroah.com>
References: <1406142278-21067-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406142278-21067-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:04:38PM +0200, Fabian Frederick wrote:
> Fix following sh-allmodconfig errors reported on kisskb
> "
> drivers/built-in.o: In function `ion_vm_fault':
> ion.c:(.text+0x1f2d8f8): undefined reference to `vm_insert_pfn'
> drivers/built-in.o: In function `ion_buffer_sync_for_device':
> ion.c:(.text+0x1f316bc): undefined reference to `zap_page_range'
> make: *** [vmlinux] Error 1
> "
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> 
> This is untested.

I'd like to see it tested before I apply it...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3DWSyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:54:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37320 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab3DWSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:54:00 -0400
Date: Tue, 23 Apr 2013 19:53:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] fbdev/sa1100fb: use vm_iomap_memory()
Message-ID: <20130423185350.GV14496@n2100.arm.linux.org.uk>
References: <1366699018-5439-1-git-send-email-tomi.valkeinen@ti.com> <1366699018-5439-7-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366699018-5439-7-git-send-email-tomi.valkeinen@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 09:36:54AM +0300, Tomi Valkeinen wrote:
> Use vm_iomap_memory() instead of [io_]remap_pfn_range().
> vm_iomap_memory() gives us much simpler API to map memory to userspace,
> and reduces possibilities for bugs.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaBLVMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:12:38 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:57601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaBLVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:12:21 -0500
Date: Wed, 12 Feb 2014 13:11:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: dl9pf@gmx.de
Cc: Behan Webster <behanw@converseincode.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, acpi: LLVMLinux: Remove nested functions from
 Thinkpad ACPI
Message-ID: <20140212211159.GA29409@infradead.org>
References: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 09:58:46PM +0100, dl9pf@gmx.de wrote:
> being able to compile the Linux kernel with Clang. The use of nested functions
> blocks this effort.

Is there any good way to make gcc warn about the use of nested functions?


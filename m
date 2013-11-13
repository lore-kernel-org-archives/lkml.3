Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab3KMIPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:15:14 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab3KMIO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:14:58 -0500
Date: Wed, 13 Nov 2013 00:14:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 0/3] Bring SFI support to out-of-tree driver modules on
 Intel Mid
Message-ID: <20131113081445.GA19388@infradead.org>
References: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 02:13:37PM -0800, David Cohen wrote:
> Hi,
> 
> This patchset extends sfi_device() macro support to driver modules.
> The main use case is to allow external driver modules to be enumerated by SFI
> on Intel Mid platforms.

How about you merge those module again?  Remember code added to the
kernel without users isn't testable, and out of tree modules do not
bring us any value add.


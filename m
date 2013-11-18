Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3KRP2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:28:24 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KRP2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:28:18 -0500
Date: Mon, 18 Nov 2013 07:28:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: mingo@kernel.org, hch@infradead.org, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH v1.1] x86: intel-mid: add test module for sfi_device()
Message-ID: <20131118152806.GB19649@infradead.org>
References: <1384370961-30847-1-git-send-email-david.a.cohen@linux.intel.com>
 <1384560558-10462-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384560558-10462-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 04:09:18PM -0800, David Cohen wrote:
> This patch adds a test module to validate sfi_device() when used from a
> driver module.

I don't think this is all that useful.  How about you prepeare a few
of the more useful drivers from your tree for submission instead?


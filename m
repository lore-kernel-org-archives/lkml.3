Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbaGWLX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:23:58 -0400
Received: from mta-out1.inet.fi ([62.71.2.201]:60466 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbaGWLX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:23:56 -0400
Date: Wed, 23 Jul 2014 14:23:47 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v8 02/22] Allow page fault handlers to perform the COW
Message-ID: <20140723112347.GB10317@node.dhcp.inet.fi>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b765e16e66c9422c896294a11fe624ecb7e44384.1406058387.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b765e16e66c9422c896294a11fe624ecb7e44384.1406058387.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:47:50PM -0400, Matthew Wilcox wrote:
> Currently COW of an XIP file is done by first bringing in a read-only
> mapping, then retrying the fault and copying the page.  It is much more
> efficient to tell the fault handler that a COW is being attempted (by
> passing in the pre-allocated page in the vm_fault structure), and allow
> the handler to perform the COW operation itself.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov

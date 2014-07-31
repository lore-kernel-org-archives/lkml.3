Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaGaRKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:10:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaGaRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:10:19 -0400
Date: Thu, 31 Jul 2014 10:10:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, suruchi <suruchi.a.kadu@intel.com>,
        ak <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "hubert.nueckel" <hubert.nueckel@intel.com>,
        beth.marsh-prime@intel.com, "doug.nelson" <doug.nelson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [Regression 3.16-rc kernel] -55% reduction in throughput for
 OLTP benchmark
Message-ID: <20140731171017.GA16455@infradead.org>
References: <1406584299.2970.924.camel@schen9-DESK>
 <20140729141908.GA4464@infradead.org>
 <1406651702.2970.927.camel@schen9-DESK>
 <20140729164951.GA23863@infradead.org>
 <1406678232.2970.943.camel@schen9-DESK>
 <20140730001248.GA32367@infradead.org>
 <1406823230.2970.946.camel@schen9-DESK>
 <CA+55aFzqKyM9_-KZsyABNFZcU3ECPCCFfyHmBrBiDzK3q02gLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzqKyM9_-KZsyABNFZcU3ECPCCFfyHmBrBiDzK3q02gLw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 10:07:55AM -0700, Linus Torvalds wrote:
> > Tested-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Tested-by: Suruchi Kadu <suruchi.a.kadu@intel.com>
> 
> Ok, good, patch looks fine. Christoph, do you have a commit message for it?

I have it queued in the vfs tree in for-next, although only with Tim's
tested-by tag, not Suruchis:

http://git.infradead.org/users/hch/vfs.git/commitdiff/d0c9ddc0a2c3036f1ab06ddf19151d5d57cad279

I was going to prepare a pull request with just that patch for you later
today or early tomorrow.


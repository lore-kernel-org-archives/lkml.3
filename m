Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaLHS4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:56:41 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:39532 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaLHS4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:56:40 -0500
Date: Mon, 8 Dec 2014 20:56:35 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
Message-ID: <20141208185635.GA25867@node.dhcp.inet.fi>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
 <20141208164650.GB29028@node.dhcp.inet.fi>
 <20141208175805.GB22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208175805.GB22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 05:58:05PM +0000, Al Viro wrote:
> On Mon, Dec 08, 2014 at 06:46:50PM +0200, Kirill A. Shutemov wrote:
> 
> > I guess this crash is related to the patchset.
> 
> Might be.  Do you have a reproducer for it?

trinity triggers it for me in few minutes. I will try find out more once
get some time.

-- 
 Kirill A. Shutemov

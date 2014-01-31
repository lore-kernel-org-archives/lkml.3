Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaAaKXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:23:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55901 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaAaKXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:23:14 -0500
Date: Fri, 31 Jan 2014 11:23:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        llvmlinux@lists.linuxfoundation.org
Subject: Re: [PATCH] x86: Build 16-bit code with -m16 where possible
Message-ID: <20140131102312.GA1534@amd.pavel.ucw.cz>
References: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
 <1389180083-23249-3-git-send-email-David.Woodhouse@intel.com>
 <1390997485.20153.129.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390997485.20153.129.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-01-29 12:11:25, David Woodhouse wrote:
> Both clang 3.5 and GCC 4.9 will support this (as of r207196 and r199754
> respectively). Both have been tested to produce booting kernels when the
> 16-bit code is built with -m16. (Modulo LLVM PR3997, at least.)

Will this break compilation with older GCC versions? Current minimum
gcc is 3.2.

								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

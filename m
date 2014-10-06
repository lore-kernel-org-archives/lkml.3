Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaJFNJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:09:20 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:45823 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaJFNJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:09:19 -0400
Date: Mon, 6 Oct 2014 14:49:15 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Joe Perches <joe@perches.com>
Cc: linux-mips <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mips: Convert pr_warning to pr_warn
Message-ID: <20141006124915.GA29036@linux-mips.org>
References: <1412441442.3247.138.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412441442.3247.138.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 09:50:42AM -0700, Joe Perches wrote:

> Use the much more common pr_warn instead of pr_warning
> with the goal of removing pr_warning eventually.

While I agree that only one of pr_warn and pr_warning deserves to live
picking pr_warning introduces another logic inconsistency - for each
pr_<foo> function there is a KERN_<FOO> severity symbol.  And that in
this case is named KERN_WARNING, there's no KERN_WARN.

  Ralf

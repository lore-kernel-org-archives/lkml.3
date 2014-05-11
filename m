Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbaEKMgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 08:36:14 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:52978 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbaEKMgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 08:36:09 -0400
Date: Sun, 11 May 2014 08:36:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: George Spelvin <linux@horizon.com>, akpm@linux-foundation.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] Add lib/glob.c
Message-ID: <20140511123605.GB22945@htj.dyndns.org>
References: <20140510031356.22726.qmail@ns.horizon.com>
 <536E61EE.3000705@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536E61EE.3000705@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 10:29:18AM -0700, Randy Dunlap wrote:
> > +	  select this option.  Say N unless you are compiling an out-of
> > +	  tree driver which tells you it depend on it.
> 
> 	To support out-of-tree drivers, I'm pretty sure that you will need
> 	to use obj- instead of lib-.  lib- drops unused code, like Tejun said.

I don't think we need to worry about out-of-tree drivers from the
beginning.

Thanks.

-- 
tejun

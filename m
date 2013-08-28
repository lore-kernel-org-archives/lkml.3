Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3H1M2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:28:16 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:44298 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3H1M2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:28:13 -0400
Date: Wed, 28 Aug 2013 08:28:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: status of the memblock tree
Message-ID: <20130828122809.GC18348@mtj.dyndns.org>
References: <20130828163459.3eb7fc0d7ae531494f605831@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828163459.3eb7fc0d7ae531494f605831@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Stephen.

On Wed, Aug 28, 2013 at 04:34:59PM +1000, Stephen Rothwell wrote:
> I was wondering if the memblock tree needs to exist any more.  The last
> commit to it was in December 2011 and was merged into Linus' tree during
> the v3.3 merge window.

After the rewrite was complete, the tree was never used.  I think it
can be put to rest now.  Ingo is routing all memblock changes now.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaLJLaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:30:21 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35413 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaLJLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:30:19 -0500
Date: Wed, 10 Dec 2014 03:30:14 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 10
Message-ID: <20141210113014.GB10836@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20141210204822.3359b7ef@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210204822.3359b7ef@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Wed, Dec 10, 2014 at 08:48:22PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add stuff destined for v3.20 until after v3.19-rc1 is
> released.
> 
> Changes since 20141209:
> 
> Dropped tree: access_once
> 
> The thermal tree lost its build failure.
> 

Just a FYI.

As of -next 20141210 commit d32394fae95741d733b174ec1446f27765f80233,
which caused a suspend hang bug [1], is still in the tree.  Greg created
a revert patch for it in driver-core [2] but I am not sure if this will
make its way to -next.

  [1]: https://lkml.org/lkml/2014/12/3/215

  [2]: https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git/commit/?h=driver-core-testing&id=f1c488a78d9f1a22cdb15648c15e70fd82ed229a

-- 
- Jeremiah Mahler

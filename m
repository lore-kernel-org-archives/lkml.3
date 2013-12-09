Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab3LIX0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:26:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:34094 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3LIX0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:26:30 -0500
Message-ID: <1386631570.32037.40.camel@pasglop>
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>,
        linux-next <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 10:26:10 +1100
In-Reply-To: <20131210101031.82b02468d32ddb89481b24b9@canb.auug.org.au>
References: <20131209191015.22974.31604.stgit@mars>
	 <20131210101031.82b02468d32ddb89481b24b9@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 10:10 +1100, Stephen Rothwell wrote:
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Works for me.  Thanks.  I will add this to linux-next today if Ben
> doesn't add it to his tree.

I will but probably not soon enough for your cut today

Cheers,
Ben.



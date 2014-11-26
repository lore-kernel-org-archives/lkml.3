Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaKZDbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 22:31:40 -0500
Received: from ozlabs.org ([103.22.144.67]:41396 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaKZDbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 22:31:39 -0500
In-Reply-To: <1416838073-16642-1-git-send-email-ldufour@linux.vnet.ibm.com>
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>, paulus@samba.org
Subject: Re: pseries/le: Fix endiannes issue in RTAS call from xmon
Message-Id: <20141126033136.977771401AC@ozlabs.org>
Date: Wed, 26 Nov 2014 14:31:36 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-24-11 at 14:07:53 UTC, Laurent Dufour wrote:
> On pseries system (LPAR) xmon failed to enter when running in LE mode, system
> is hunging. Inititating xmon will lead to such an output on the console:

OK. You say "LPAR", by which you mean "under phyp" I think. I haven't seen this
under KVM, and it looks like KVM doesn't implement "set-indicator" so that
would explain that.

I'll take this as a bug fix and CC it to stable.

cheers

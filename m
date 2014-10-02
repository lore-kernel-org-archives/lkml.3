Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaJBPNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:13:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaJBPNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:13:23 -0400
Date: Thu, 2 Oct 2014 11:13:02 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
Message-ID: <20141002151302.GA15348@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com>
 <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org>
 <542C749B.1040103@oracle.com>
 <alpine.LSU.2.11.1410020154500.6444@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1410020154500.6444@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:23:08AM -0700, Hugh Dickins wrote:

 > I think these patches are fine for investigating whatever is the
 > problem currently afflicting you and mm under trinity; but we all
 > have our temporary debugging patches, I don't think all deserve
 > preservation in everyone else's kernel, that amounts to far more
 > clutter than any are worth.

One problem with keeping things like this in -mm (or other non-Linus tree)
is that they bit-rot quickly, and become a pain to apply, especially if
they are perpetually on top of other changes in -mm.

I looked at trying these patches on Linus' tree when Sasha posted them,
but lost motivation when I realized they needed other bits of -mm too.

It may be that after Andrews 3.18+ mega-merge things would be simpler,
but I have a feeling it wouldn't be long before the situation would
arise again.

	Dave


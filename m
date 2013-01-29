Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3A2BHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:07:20 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48858 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3A2BHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:07:18 -0500
Date: Mon, 28 Jan 2013 17:07:15 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Anton Arapov <anton@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/11] ksm: NUMA trees and page migration
In-Reply-To: <20130128155452.16882a6e.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1301281701010.4947@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <20130128155452.16882a6e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Andrew Morton wrote:
> On Fri, 25 Jan 2013 17:53:10 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > Here's a KSM series
> 
> Sanity check: do you have a feeling for how useful KSM is? 
> Performance/space improvements for typical (or atypical) workloads? 
> Are people using it?  Successfully?
> 
> IOW, is it justifying itself?

I have no idea!  To me it's simply a technical challenge - and I agree
with your implication that that's not a good enough justification.

I've added Marcelo and Gleb and the KVM list to the Cc:
my understanding is that it's the KVM guys who really appreciate KSM.

Hugh

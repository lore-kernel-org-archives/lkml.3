Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaE3Hjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:39:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaE3Hjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:39:54 -0400
Date: Fri, 30 May 2014 09:39:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: gleb@kernel.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Implement PEBS virtualization for Silvermont
Message-ID: <20140530073934.GC20167@laptop.programming.kicks-ass.net>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:12:03PM -0700, Andi Kleen wrote:
> PEBS is very useful (e.g. enabling the more cycles:pp event or
> memory profiling) Unfortunately it didn't work in virtualization,
> which is becoming more and more common.
> 
> This patch kit implements simple PEBS virtualization for KVM on Silvermont
> CPUs. Silvermont does not have the leak problems that prevented successfull
> PEBS virtualization earlier.

Silvermont is such an underpowered thing, who in his right mind would
run anything virt on it to further reduce performance?

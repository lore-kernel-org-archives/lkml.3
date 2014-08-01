Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaHABxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:53:40 -0400
Received: from ozlabs.org ([103.22.144.67]:44312 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaHABxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:53:39 -0400
Message-ID: <1406858017.32701.1.camel@concordia>
Subject: Re: scheduler crash on Power
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: peterz@infrdead.org, bruno@wolff.to, jwboyer@redhat.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Aug 2014 11:53:37 +1000
In-Reply-To: <20140730072242.GA21516@us.ibm.com>
References: <20140730072242.GA21516@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 00:22 -0700, Sukadev Bhattiprolu wrote:
> I am getting this crash on a Powerpc system using 3.16.0-rc7 kernel plus
> some patches related to perf (24x7 counters) that Cody Schafer posted here:
> 
> 	https://lkml.org/lkml/2014/5/27/768
> 
> I don't get the crash on an unpatched kernel though.

You mean you don't get the crash on 3.16-rc7 ?

I find it hard to believe those 24x7 patches are causing this.
 
> I am also attaching the debug messages that Peterz added
> here: https://lkml.org/lkml/2014/7/17/288

I don't see any FAIL messages in your log, so it looks like you're not hitting
the case that patch was looking for?

> Appreciate any debug suggestions.

Reproduce on an unpatched kernel.

cheers



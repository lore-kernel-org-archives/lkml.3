Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3GYLE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:04:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35270 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab3GYLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:04:58 -0400
Date: Thu, 25 Jul 2013 13:04:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] perf tools: Add support for pinned modifier
Message-ID: <20130725110447.GS27075@twins.programming.kicks-ass.net>
References: <1374632802-15436-1-git-send-email-michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374632802-15436-1-git-send-email-michael@ellerman.id.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:26:42PM +1000, Michael Ellerman wrote:
> 
> I would have used "p" obviously, but that's taken. Are folks happy that
> "P" is sufficiently different from "p"? I couldn't think of anything
> better.

I've seen proposals where 'P' is used for the max 'p' level :/

But yes, vexing situation. 

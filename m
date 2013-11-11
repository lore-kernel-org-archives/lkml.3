Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3KKQ1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:27:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38214 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3KKQ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:27:29 -0500
Date: Mon, 11 Nov 2013 17:27:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        mingo@redhat.com
Subject: Re: [PATCH v3 1/2] ARC: Add perf support for ARC700 cores
Message-ID: <20131111162715.GB26898@twins.programming.kicks-ass.net>
References: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
 <1383832512-21130-2-git-send-email-mjonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383832512-21130-2-git-send-email-mjonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 02:55:11PM +0100, Mischa Jonker wrote:
> This adds basic perf support for ARC700 cores. Most PERF_COUNT_HW* events
> are supported now.

I don't see anything particularly weird, but then I don't know/have the
hardware so I suppose you know what you're doing :-)

Acked-by: Peter Zijlstra <peterz@infradead.org>



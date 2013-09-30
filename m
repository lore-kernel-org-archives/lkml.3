Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3I3Ha4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:30:56 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:41882 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3I3Hay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:30:54 -0400
Date: Mon, 30 Sep 2013 09:30:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 force enabling perf events
Message-ID: <20130930073040.GB13967@gmail.com>
References: <20130929053852.GS18242@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929053852.GS18242@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> 
> Frederic,
> 
> I noticed that an allnoconfig x86 build builds perf events.

The most straightforward way to support stripped-down kernels disabling 
perf events would be to allow hardware breakpoint support to be 
disable-able, under CONFIG_EXPERT=y or so.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3IIILL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:11:11 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:62969 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3IIILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:11:08 -0400
Date: Mon, 9 Sep 2013 10:11:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: perf, x86: Add parts of the remaining haswell PMU functionality
 v5
Message-ID: <20130909081104.GA19980@gmail.com>
References: <1378438661-24765-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378438661-24765-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> I hope this version is ok for everyone now.

This version arrived in the middle of the merge window, will look after 
-rc1 has been released.

If there are any bugfixes (or erratum fixes/workarounds) pending then 
you'll need to send them separately against the current code base.

Thanks,

	Ingo

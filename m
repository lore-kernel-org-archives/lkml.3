Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3HaDGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 23:06:39 -0400
Received: from science.horizon.com ([71.41.210.146]:52155 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753903Ab3HaDGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 23:06:37 -0400
Date: 30 Aug 2013 23:06:33 -0400
Message-ID: <20130831030633.28455.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: torvalds@linux-foundation.org
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless update of refcount
Cc: linux@horizon.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        waiman.long@hp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticing that you are adding several functions that return a boolean
value as an int.  And a "gotref" local variable.

Is that just not wanting to bother with thse newfangled C99 innovations,
or do you dislike the "bool" type for some reason?

Even if it doesn't change the code in the slightest, I like to declare
things with the bool type for documentation.  I can see avoiding code
churn, but this is all new code, so I thought I'd ask.

(FWIW, stdbool.h was in gcc 3.2, which README says is the minimum
supported version, although that's probably outdated information.)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaKLAFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:05:08 -0500
Received: from one.firstfloor.org ([193.170.194.197]:60592 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaKLAFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:05:07 -0500
Date: Wed, 12 Nov 2014 01:05:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Add --branch-history option to report
Message-ID: <20141112000505.GM12538@two.firstfloor.org>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-3-git-send-email-andi@firstfloor.org>
 <87mw8ogaj8.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mw8ogaj8.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And please also add a new CCKEY_SRCLINE if you print srcline with the
> callchains so that users can give "-g srcline" if they want (regardless
> of the branch history feature).

That would be largely identical to CCKEY_ADDRESS 
except for the case of two calls to the same function from
the same line. Probably not worth adding?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

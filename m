Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbaEJMXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 08:23:15 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:49630 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaEJMXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 08:23:13 -0400
Date: Sat, 10 May 2014 08:23:09 -0400
From: Tejun Heo <tj@kernel.org>
To: George Spelvin <linux@horizon.com>
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] Add lib/glob.c
Message-ID: <20140510122309.GB4721@mtj.dyndns.org>
References: <20140313121032.GA9981@htj.dyndns.org>
 <20140510031356.22726.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510031356.22726.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ooh, one more nitpick.

On Fri, May 09, 2014 at 11:13:56PM -0400, George Spelvin wrote:
> +/**
> + * glob_match - Shell-style pattern matching, like !fnmatch(pat, str, 0)
> + * @pat: Pattern to match.  Metacharacters are ?, *, [ and \.
> + *       (And, inside character classes, !, - and ].)

@ARG lines should be contained in a single line.  Just "Pattern to
match." should do.  With detailed description in the body.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaIQQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:26:16 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33870 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaIQQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:26:14 -0400
Date: Wed, 17 Sep 2014 09:26:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 15/22] Input: edt-ft5x06 - Replace strnicmp with
 strncasecmp
Message-ID: <20140917162608.GA25297@core.coreip.homeip.net>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
 <1410900696-6481-16-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410900696-6481-16-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 10:51:29PM +0200, Rasmus Villemoes wrote:
> The kernel used to contain two functions for length-delimited,
> case-insensitive string comparison, strnicmp with correct semantics
> and a slightly buggy strncasecmp. The latter is the POSIX name, so
> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
> for the new strncasecmp to avoid breaking existing users.
> 
> To allow the compat wrapper strnicmp to be removed at some point in
> the future, and to avoid the extra indirection cost, do
> s/strnicmp/strncasecmp/g.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied, thank you.

-- 
Dmitry

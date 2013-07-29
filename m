Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3G2UKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:10:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34332 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753875Ab3G2UKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:10:13 -0400
Message-ID: <1375128613.2075.56.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: enforce sane perl version
From: Joe Perches <joe@perches.com>
To: Dave Hansen <dave@sr71.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 13:10:13 -0700
In-Reply-To: <20130729200606.2651EE1E@viggo.jf.intel.com>
References: <20130729200606.2651EE1E@viggo.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 13:06 -0700, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> I got a bug report from a couple of users who said
> checkpatch.pl was broken for them.  It was erroring out on
> fairly random lines most commonly with messages like:
> 
> 	Nested quantifiers in regex; marked by <--HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at ./checkpatch.pl line 340.
> 
> The bug reporter was running a version of perl 5.8 which was
> end-of-lifed in 2008: http://www.cpan.org/src/.  Versions of perl
> this old are at _best_ quite untested.  At worst, they are crusty
> and known to be completely broken.
> 
> If folks have a system _that_ old, then we should have mercy on
> them and give them a half-decent error message rather than fail
> with nutty error messages.
> 
> This patch enforces that checkpatch.pl is run with perl 5.10,
> which was end-of-lifed in 2009.  The new --ignore-perl-version
> command-line switch will let folks override this if they want.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Other than Andrew Morton's (continuing?) use of perl 5.8
I'm fine with this.

Andrew?  Time to update your perl version?



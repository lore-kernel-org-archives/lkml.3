Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3GHDyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 23:54:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46082 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752183Ab3GHDyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 23:54:06 -0400
Message-ID: <1373255644.1893.3.camel@joe-AO722>
Subject: Re: [v9fs:for-linus 7/7] ERROR: code indent should use tabs where
 possible
From: Joe Perches <joe@perches.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Jim Garlick <garlick@llnl.gov>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 07 Jul 2013 20:54:04 -0700
In-Reply-To: <20130708033004.GA20091@localhost>
References: <51d9c6c4.k6qhnvy45dNR8Ghq%fengguang.wu@intel.com>
	 <20130708004233.GA8958@localhost>
	 <CAFkjPTk5EZ_d5BdTTHjgrwdtU1XfZ3go_7ZDCv4Q_oqnn95AHg@mail.gmail.com>
	 <20130708033004.GA20091@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 11:30 +0800, Fengguang Wu wrote:
> In long run I'd like to disable
> the check types that tend to have false positives.  As for now, these
> checks are disabled in my checkpatch robot:

Are you using a .checkpatch.conf file?

> PATCH_PREFIX
> LONG_LINE
> CAMELCASE

That's a --strict test

> MISSING_SIGN_OFF

Why would you even consider this one?

> COMPLEX_MACRO
> BRACES
> SPACING
> LONG_LINE

OK by me.

> REDUNDANT_CODE

Also a --strict test

> TRAILING_STATEMENTS

False positives?  Got an example?

> UNCOMMENTED_DEFINITION



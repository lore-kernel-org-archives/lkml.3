Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3DOEia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:38:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47647 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751921Ab3DOEi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:38:28 -0400
Message-ID: <1366000708.1878.34.camel@joe-AO722>
Subject: Re: [PATCH 1/2] hfs/hfsplus: Convert dprint to hfs_dbg
From: Joe Perches <joe@perches.com>
To: htl10@users.sourceforge.net
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Apr 2013 21:38:28 -0700
In-Reply-To: <1365999738.30513.YahooMailClassic@web172302.mail.ir2.yahoo.com>
References: <1365999738.30513.YahooMailClassic@web172302.mail.ir2.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 05:22 +0100, Hin-Tak Leung wrote:
> How is converting a few hundred lines of "print nothing" to
> another few hundred lines of "print nothing" functional?
> What does it achieve?

Standardization of output style when enabled.
Easier conversion to pr_debug/dynamic_debugging.
Emitting at KERN_DEBUG when enabled.

Besides, I was also doing the other logging
conversions at the same time to prefix hfs
differently than hfsplus.

I don't really care much when this stuff is
done, (it took about 10 minutes and it's about
all automatic and scripted) but I do think it
should be done.


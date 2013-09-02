Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab3IBUh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:37:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37567 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab3IBUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:37:28 -0400
Date: Mon, 2 Sep 2013 23:37:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        David Howells <dhowells@redhat.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Add warning about submitting patches using
 --file
Message-ID: <20130902203705.GN19256@mwanda>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <1378150847.1953.106.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378150847.1953.106.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 12:40:47PM -0700, Joe Perches wrote:
> +WARNING: When using --file mode, do not send patches that just make
> +whitespace or formatting changes unless more significant changes are
> +also made for other reasons in another patch.
> +

This is a run on sentence.  Also I don't agree with it.  Clean up
patches are good on their own.  There are parts of the kernel which are
not just in staging where I refuse to look at because it is so bad.

The problem is that people send "clean up" patches which don't clean up
the code or which make the code worse than the original.  All they care
about is pleasing checkpatch.pl instead of actually thinking about what
they are doing.  The message should just say something like, "Take a
step back and think about if this actually improves things for human
readers."

regards,
dan carpenter


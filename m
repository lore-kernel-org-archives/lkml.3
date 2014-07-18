Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbaGRN4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:56:22 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37488 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761298AbaGRN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:56:18 -0400
Date: Fri, 18 Jul 2014 06:56:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Richard Weinberger <richard@nod.at>
Cc: Borislav Petkov <bp@suse.de>, akpm@linux-foundation.org, apw@canonical.com,
        joe@perches.com, tytso@mit.edu, dwalter@google.com, neilb@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140718135612.GA18432@roeck-us.net>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
 <53C8CCE1.4000105@roeck-us.net>
 <20140718082324.GA31270@pd.tnic>
 <53C92332.5010807@roeck-us.net>
 <53C92535.2010605@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C92535.2010605@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 03:46:29PM +0200, Richard Weinberger wrote:
> Am 18.07.2014 15:37, schrieb Guenter Roeck:
> > On 07/18/2014 01:23 AM, Borislav Petkov wrote:
> >> On Fri, Jul 18, 2014 at 12:29:37AM -0700, Guenter Roeck wrote:
> >>> First, 'abuse' is a relative term. It describes a use you
> >>> (and possibly many others) may find objectionable, but that
> >>> does not mean all uses are objectionable.
> >>
> >> Do you actually have a valid use case for keeping the cmdline switch ...
> >>
> > 
> > I find it convenient to be able to check a new file before committing it
> > and creating a patch. Also, I find it convenient to be able use it to clean
> > up a file before I do heavy lifting with it. Yes, I understand the latter
> > is discouraged nowadays, and I would not use it anymore outside my scope
> > of responsibility unless specifically asked by the maintainer to do so,
> > but in such cases it helps me a lot to be able to address the cleanup
> > prior to the heavy lifting.
> 
> As capable kernel hacker you can still use a command like:
> diff -urN /dev/null $file | ./scripts/checkpatch.pl -
> 

Yes, that came up before. Or I can revert the patch locally, or keep an old
version of checkpatch around. You make me suffer because someone else abuses
the system. That someone will find other ways to abuse the system, such as
using the same approach, or annoy you with something else, such as searching
for "fixme" statements in the code or sending unhelpful emails about failing
builds. The one thing you will not accomplish is to solve the problem.

Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3DSGKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:10:35 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:40838 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab3DSGK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:10:28 -0400
Date: Thu, 18 Apr 2013 23:08:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC 5/7] Docs: Expectations for bug reporters and maintainers
Message-ID: <20130419060854.GA16563@kroah.com>
References: <412f8f434c32c557b8c17e73163d003b895e2e56.1366046390.git.sarah.a.sharp@linux.intel.com>
 <1366164906.18069.110@driftwood>
 <20130417182328.GA7690@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130417182328.GA7690@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 11:23:28AM -0700, Sarah Sharp wrote:
> TLDR version: Yes, it would be nice if bug reporters could go up the
> hierarchy, but they don't have an easy way to know which subsystem
> maintainers to contact.  Perhaps a new line in MAINTAINERS for the
> subsystem maintainer would be helpful?

We have that already for a number of subsystems, look at the entry for
"USB SUBSYSTEM" for one such example, and there are 49 others in there
as well :)

Thanks for rewriting this document, it looks much better now.

greg k-h

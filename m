Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab3GWXUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:20:15 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51898 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466Ab3GWXUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:20:13 -0400
Date: Tue, 23 Jul 2013 18:20:07 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: update references to v2.6.x in
 development-process
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
	<20130716113349.274da843@lwn.net> <51E69D50.10000@windriver.com>
In-Reply-To: <51E69D50.10000@windriver.com> (from
	paul.gortmaker@windriver.com on Wed Jul 17 08:34:08 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1374621607.3031.3@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 08:34:08 AM, Paul Gortmaker wrote:
> On 13-07-16 01:33 PM, Jonathan Corbet wrote:
> > On Mon, 15 Jul 2013 19:34:44 -0400
> > Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >
> >> The last mainline release of a v2.6.x kernel was back in May 2011.
> >> Here we update references to be 3.x based, which also means  
> updating
> >> some dates and statistics.
> >
> > Ccing the author of the document never hurts :)
> 
> It might be worth sticking an entry in MAINTAINERS for that dir.
> If one had asked me who wrote it, I probably would have recalled that
> info, but instead I just out of habit ran get_maintainers...

I note that every file people stick a MAINTAINERS entry for in  
Documentation is one that I _don't_ bother with. Just FYI.

(Yes, 5 days behind on the list, but catching up...)

Rob
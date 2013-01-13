Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3AMOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 09:25:26 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57840 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab3AMOZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 09:25:25 -0500
Date: Sun, 13 Jan 2013 05:44:33 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 1/2] Fix wrong EOF compare
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@shadowen.org>,
        Alexander Nyberg <alexn@dsv.su.se>,
        Randy Dunlap <rdunlap@infradead.org>
References: <1357871401-7075-1-git-send-email-minchan@kernel.org>
	<xa1tbocvby0s.fsf@mina86.com>
In-Reply-To: <xa1tbocvby0s.fsf@mina86.com> (from mina86@mina86.com on Fri
	Jan 11 08:21:55 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1358077473.32505.10@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 08:21:55 AM, Michal Nazarewicz wrote:
> On Fri, Jan 11 2013, Minchan Kim <minchan@kernel.org> wrote:
> > The C standards allows the character type char to be singed or  
> unsinged,
> > depending on the platform and compiler. Most of systems uses signed  
> char,
> > but those based on PowerPC and ARM processors typically use  
> unsigned char.
> > This can lead to unexpected results when the variable is used to  
> compare
> > with EOF(-1). It happens my ARM system and this patch fixes it.
> >
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Andy Whitcroft <apw@shadowen.org>
> > Cc: Alexander Nyberg <alexn@dsv.su.se>
> > Cc: Michal Nazarewicz <mina86@mina86.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  Documentation/page_owner.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)

My kernel tree doesn't have Documentation/page_owner.c, where do I find  
this file?

Rob
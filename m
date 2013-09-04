Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486Ab3IDS7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:59:35 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48989 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450Ab3IDS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:59:21 -0400
Date: Wed, 4 Sep 2013 11:59:38 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH -next] bcache: fix btree printk format warning
Message-ID: <20130904185938.GB27467@kmo-pixel>
References: <20130904181300.06fbf0698863cfaacf9fad9a@canb.auug.org.au>
 <52277576.5020805@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52277576.5020805@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 11:01:26AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix printk format warning on i386:

I've sent out the fix for this, Jens just hasn't pulled it yet.

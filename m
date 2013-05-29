Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3E2Fgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:36:43 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37740 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3E2Fgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:36:41 -0400
Date: Tue, 28 May 2013 20:01:13 -0400
From: Kumar amit mehta <gmate.amit@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: neilb@suse.de, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] md: bcache: io.c: fix a potential NULL pointer
 dereference
Message-ID: <20130529000113.GA6648@gmail.com>
References: <1369726275-5424-1-git-send-email-gmate.amit@gmail.com>
 <20130529002041.GC2291@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529002041.GC2291@google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 05:20:41PM -0700, Kent Overstreet wrote:
> On Tue, May 28, 2013 at 12:31:15AM -0700, Kumar Amit Mehta wrote:
> > bio_alloc_bioset returns NULL on failure. This fix adds a missing check
> > for potential NULL pointer dereferencing.
> 
> Whoops, that's definitely a bug. Thanks, applied.
> 
> How'd you find it?

Using smatch[1]

[1] http://smatch.sourceforge.net/

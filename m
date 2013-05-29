Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab3E2AUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:20:47 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43397 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab3E2AUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:20:44 -0400
Date: Tue, 28 May 2013 17:20:41 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: neilb@suse.de, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] md: bcache: io.c: fix a potential NULL pointer
 dereference
Message-ID: <20130529002041.GC2291@google.com>
References: <1369726275-5424-1-git-send-email-gmate.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369726275-5424-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:31:15AM -0700, Kumar Amit Mehta wrote:
> bio_alloc_bioset returns NULL on failure. This fix adds a missing check
> for potential NULL pointer dereferencing.

Whoops, that's definitely a bug. Thanks, applied.

How'd you find it?

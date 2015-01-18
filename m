Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbbAREOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 23:14:42 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:65261 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbbAREOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 23:14:41 -0500
From: Andrew Milkovich <amilkovich@gmail.com>
X-Google-Original-From: Andrew Milkovich <root@zenbook.hsd1.ca.comcast.net>
Date: Sat, 17 Jan 2015 20:14:38 -0800
To: Joe Perches <joe@perches.com>
Cc: Andrew Milkovich <amilkovich@gmail.com>, benjamin.romer@unisys.com,
        david.kershner@unisys.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: unisys: virtpci: fixed coding style errors
Message-ID: <20150118041438.GC1937@zenbook.hsd1.ca.comcast.net>
References: <1421551812-14371-1-git-send-email-amilkovich@gmail.com>
 <1421553712.29879.5.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421553712.29879.5.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 08:01:52PM -0800, Joe Perches wrote:
> On Sat, 2015-01-17 at 19:30 -0800, Andrew Milkovich wrote:
> > Fixed coding style errors per checkpatch.pl.
> 
> which ones?
> 
> As far as I can tell, none of the checkpatch
> warnings on this file are actually addressed
> by this patch.
> 
> 

I see, you are correct. Before there was whitespace after the inline comments,
but on the staging-testing branch this has already been fixed.

Thanks, I'll look into the current checkpatch.pl issues.

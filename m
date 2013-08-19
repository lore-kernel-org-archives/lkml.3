Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab3HSRyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:54:11 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33865 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3HSRyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:54:09 -0400
Message-ID: <1376934845.24869.43.camel@bobble.lax.corp.google.com>
Subject: Re: [dm-devel] dm: Make MIN_IOS, et al, tunable via sysctl.
From: Frank Mayhar <fmayhar@google.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 19 Aug 2013 10:54:05 -0700
In-Reply-To: <20130819140016.GB27167@redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
	 <20130819140016.GB27167@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 10:00 -0400, Mike Snitzer wrote:
> Performance isn't the concern.  The concern is: does DM allow for
> forward progress if the system's memory is completely exhausted?
> 
> This is why request-based has such an extensive reserve, because it
> needs to account for cloning the largest possible request that comes in
> (with multiple bios).

Thanks for the response.  In our particular case, I/O will be file
system based and over a network, which makes it pretty easy for us to be
sure that large I/Os never happen.  That notwithstanding, however, as
you said it just seems reasonable to make these values configurable.

I'm also looking at making some similar constants in dm-verity and
dm-bufio configurable in the same way and for similar reasons.
-- 
Frank Mayhar
310-460-4042


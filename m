Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab3JGSNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:13:42 -0400
Received: from longford.logfs.org ([213.229.74.203]:58003 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3JGSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:13:36 -0400
Date: Mon, 7 Oct 2013 12:53:44 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-mtd@lists.infradead.org, Joern Engel <joern@lazybastard.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: phram: Make phram 64-bit compatible
Message-ID: <20131007165344.GA10162@logfs.org>
References: <524C4CF5.7060601@nsn.com>
 <20131007174943.GB23337@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131007174943.GB23337@ld-irv-0074.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 October 2013 10:49:43 -0700, Brian Norris wrote:
> 
> [After more research:] It looks like this topic may be the subject of
> some long-past flame wars. If I am digging up past demons, then I'd
> prefer to let sleeping Balrogs lie.

Most of the time it is obvious from context whether you want base-1000
or base-1024 numbers.  So in the common case the extra letter is plain
annoying.  In less common cases it matters a lot and lack of the extra
letter is rather irritating.

One possible solution would be to have three suffixes.  Ki for
base-1024, Kd for base-1000 and K for "I don't care, you decide for
me".  But I am sure that would simply cause another round of
flamewars.

It is not a hard technical problem.  As a result, noone on this list
has the required expertise to solve it.

Jörn

--
Money can buy bandwidth, but latency is forever.
-- John R. Mashey

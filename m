Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaHYFVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 01:21:40 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38571 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaHYFVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 01:21:39 -0400
Date: Sun, 24 Aug 2014 22:21:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 25
Message-ID: <20140825052135.GA1878@roeck-us.net>
References: <20140825145133.019ca740@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825145133.019ca740@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 02:51:33PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140823:
> 
> The mfd tree still had its build failure so I used the version from
> next-20140822.
> 
> The pwm tree last its build failure.
> 
> The staging tree still had its build failure for which I applied a
> fix patch.
> 
> Non-merge commits (relative to Linus' tree): 1539
>  1489 files changed, 40632 insertions(+), 27956 deletions(-)
> 

Quick test shows same problems (and fixes) as with 8/23 tree.

Guenter

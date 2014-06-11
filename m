Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaFKRjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:39:00 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34851 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaFKRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:38:59 -0400
Date: Wed, 11 Jun 2014 18:38:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Denis Kirjanov <kda@linux-powerpc.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: kmemleak: Unable to handle kernel paging request
Message-ID: <20140611173851.GA5556@MacBook-Pro.local>
References: <CAOJe8K3fy3XFxDdVc3y1hiMAqUCPmkUhECU7j5TT=E=gxwBqHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJe8K3fy3XFxDdVc3y1hiMAqUCPmkUhECU7j5TT=E=gxwBqHg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:13:07PM +0400, Denis Kirjanov wrote:
> I got a trace while running 3.15.0-08556-gdfb9454:
> 
> [  104.534026] Unable to handle kernel paging request for data at
> address 0xc00000007f000000

Were there any kmemleak messages prior to this, like "kmemleak
disabled"? There could be a race when kmemleak is disabled because of
some fatal (for kmemleak) error while the scanning is taking place
(which needs some more thinking to fix properly).

Thanks.

-- 
Catalin

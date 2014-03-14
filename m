Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaCNA0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 20:26:39 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60968 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCNA0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 20:26:38 -0400
Date: Fri, 14 Mar 2014 00:29:13 +0000
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v3] zram: support REQ_DISCARD
Message-ID: <20140314002912.GA3068@gmail.com>
References: <1394611269-7582-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140312133318.60c5e63ba26e9bf71098cc6e@linux-foundation.org>
 <20140313024617.GA4900@lge.com>
 <20140313134035.5362a0b51b0a3c280ddc7667@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313134035.5362a0b51b0a3c280ddc7667@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 01:40:35PM -0700, Andrew Morton wrote:
> On Thu, 13 Mar 2014 11:46:17 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > Hello, Andrew.
> > 
> > I applied all your comments in below patch. :)
> 
> OK, thanks.  I'll grab this instead of v5 - I wasn't thinking very
> clearly with the lock hold time issue.  Let's go for low latency then
> worry about it later if this function starts showing on profiles.
> 
> I modified your code comments somewhat - please check.

Acked-by: Minchan Kim <minchan@kernel.org>

Thanks Joonsoo and Andrew.


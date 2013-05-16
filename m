Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3EPAsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 20:48:15 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:10509 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833Ab3EPAsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 20:48:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnUPADAslFF5LKxY/2dsb2JhbABbgweDCrhlhSAEAYEAF3SCHwEBBTocIxAIAxgJJQ8FJQMhE4gLvRYWjWuBHQeCdGEDlzORPoFYgUoq
Date: Thu, 16 May 2013 10:47:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 1/2] mm: vmscan: let any negative return value from
 shrinker mean error
Message-ID: <20130516004749.GD24635@dastard>
References: <1368454595-5121-1-git-send-email-oskar.andero@sonymobile.com>
 <1368454595-5121-2-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368454595-5121-2-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 04:16:34PM +0200, Oskar Andero wrote:
> The shrinkers must return -1 to indicate that it is busy. Instead of
> relaying on magical numbers, let any negative value indicate error. This
> opens up for using the errno.h error codes in the shrinker
> implementations.

Just what is the shrinker infrastructure supposed to do with a
random error code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaG3V5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:57:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaG3V5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:57:33 -0400
Date: Wed, 30 Jul 2014 14:57:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Documentation: SubmittingPatches: overhaul changelog
 howto
Message-ID: <20140730215705.GA25473@kroah.com>
References: <1406754661-15897-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406754661-15897-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 05:11:01PM -0400, Johannes Weiner wrote:
> Maintainers often repeat the same feedback on poorly written
> changelogs - describe the problem, justify your changes, quantify
> optimizations, describe user-visible changes - but our documentation
> on writing changelogs doesn't include these things.  Fix that.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3KNUhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:37:36 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:57138 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3KNUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:37:28 -0500
Date: Thu, 14 Nov 2013 17:37:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Remove thread summary coloring
Message-ID: <20131114203720.GC14921@ghostprotocols.net>
References: <1384447410-1771-1-git-send-email-penberg@kernel.org>
 <52853334.9020304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52853334.9020304@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 14, 2013 at 01:31:48PM -0700, David Ahern escreveu:
> On 11/14/13, 9:43 AM, Pekka Enberg wrote:
> >Thread summary line coloring looks ugly.  It doesn't add much value so
> >remove coloring completely.
> >
> >Signed-off-by: Pekka Enberg <penberg@kernel.org>
> >---
> >  tools/perf/builtin-trace.c | 13 ++-----------
> >  1 file changed, 2 insertions(+), 11 deletions(-)
> >
> 
> Looks good to me.
> Acked-by: David Ahern <dsahern@gmail.com>

Applied, and thanks David for bringing this to my attention :-)

- Arnaldo

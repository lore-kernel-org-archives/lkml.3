Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab3HARFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:05:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59272 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752667Ab3HARFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:05:53 -0400
Message-ID: <1375376752.2034.60.camel@joe-AO722>
Subject: Re: [PATCH 0/8] include/net: next set of extern removals
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org
Date: Thu, 01 Aug 2013 10:05:52 -0700
In-Reply-To: <1375375486.10515.170.camel@edumazet-glaptop>
References: <cover.1375316912.git.joe@perches.com>
	 <24958.1375358650@warthog.procyon.org.uk>
	 <1375374560.2034.52.camel@joe-AO722>
	 <1375375486.10515.170.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 09:44 -0700, Eric Dumazet wrote:
> 'extern' in include files are an easy way to have a grep friendly
> marker, and otherwise are harmless.
> 
> _You_ believe they are useless, other people think otherwise.

I believe I wrote superfluous.

> I learned C 30 years ago, and using 'extern' is quite natural for me.

I think I've got a few years headstart on you.
All that means is we're both relatively old...

cheers, Joe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaFKMz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:55:27 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56734 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaFKMzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:55:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pranith Kumar <pranith@gatech.edu>
Subject: Re: [PATCH 1/1] define generic version of cmpxchg{64} only if not, previously defined
Date: Wed, 11 Jun 2014 14:55:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5390EAAC.5070601@gatech.edu>
In-Reply-To: <5390EAAC.5070601@gatech.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201406111455.16343.arnd@arndb.de>
X-Provags-ID: V02:K0:BiJDs4JoosMAc6jtoa0hY0uakHVK6FaW3Zs1beErEuw
 nRGNF5xtqu9IL1Bl3Tn0wWXuDFp/q52HdR6ucnN7CtxlHqByJJ
 ohn2UvRtV0tDD37cY8Dz4OObqL4hNqnETWxFaY5BY1rVlcIZWA
 3aSK5GEpY2xloJRWknfE6zZf3B5Us3BwTco6LsLXpepX5uJ0Vw
 2AbgOZ4pIgntCL7k9ZBLbPgywLQsS1W96VwHbCpzMEP8IMe4aq
 1YDWLDxhaSRhIqpOpFcnSG5spB45XjVBvzOf8kKO/BKoGgKw9j
 zrSyTpnk5XWczDlQCz3oNRL9Er/J+DmUCLjYCS7qGHh1M0UDjB
 Z8A7JmT05hbQ+PsnhJxE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2014, Pranith Kumar wrote:
> 
> define generic versions of cmpxchg{64} only if not previously defined.
> 
> This makes these definition in-line to other definitions of generic versions
> 
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I assume  you have a patch that depends on this. Please queue up this first
patch in the same series as the one that needs it.

	Arnd

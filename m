Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaEHPYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:24:11 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:47133 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaEHPYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:24:09 -0400
Date: Thu, 8 May 2014 17:24:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 20/20] arch: Rewrite generic atomic support
Message-ID: <20140508152401.GA5177@ravnborg.org>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.940119622@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508135852.940119622@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> -/**
> - * atomic_add_return - add integer to atomic variable
> - * @i: integer value to add
> - * @v: pointer of type atomic_t
> - *
> - * Atomically adds @i to @v and returns the result
> - */
For people not starign at kernel code every days these sparse comments
is a help. If anything they should be improved rather than deleted.

	Sam

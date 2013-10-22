Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3JVQkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:40:31 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40508 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3JVQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:40:29 -0400
Date: Tue, 22 Oct 2013 18:40:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Mario <jmario@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] kbuild: Increase kallsyms max symbol length
Message-ID: <20131022164026.GE29695@two.firstfloor.org>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
 <1382456783-22826-2-git-send-email-andi@firstfloor.org>
 <1382459764.2041.90.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382459764.2041.90.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Doesn't doubling seems a tad excessive given the
> silly length of that symbol above?

No, it doesn't.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaH1VQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:16:23 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35791 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaH1VQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:16:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140828210010.GM5001@linux.vnet.ibm.com>
References: <1408972138-12246-1-git-send-email-bobby.prani@gmail.com>
 <53FF8B77.7000103@infradead.org> <20140828210010.GM5001@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 28 Aug 2014 17:15:50 -0400
Message-ID: <CAJhHMCDxsukXe_HW55iJp0oCAWgrosxCRX1AfocS6QBzxaD0pw@mail.gmail.com>
Subject: Re: [PATCH] doc: memory-barriers.txt: Correct example for reorderings
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 5:00 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> I am really confused by the ordering of the new lines, as I would have
> expected the "x"s to be replaced with "y"s and vice versa.  But the
> ordering of the various combinations does not matter, and each line
> looks OK.
>

Since x = A was replaced by x = B and y = B was replaced by y = A, I
just converted all x = load A to x = load B. Similarly for y. I think
we can do either this or as you suggested replacing x's with y's.

-- 
Pranith

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3G2OjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3G2OjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:39:21 -0400
Date: Mon, 29 Jul 2013 15:39:17 +0100
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: sunnikrishnan@stec-inc.com, kmo@daterainc.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [RFC] dm-lc target
Message-ID: <20130729143916.GA20119@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	sunnikrishnan@stec-inc.com, kmo@daterainc.com,
	linux-kernel@vger.kernel.org
References: <CABmKtjcsZUbafxtmPb=2-Gkxz9PkFq7KVsQBqRkHduEn7aaqkw@mail.gmail.com>
 <51F48531.6040104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F48531.6040104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 11:42:57AM +0900, Akira Hayakawa wrote:
> I wrote an introduction slide which is available in URL below:
> https://github.com/akiradeveloper/dm-lc/blob/develop/what-is-dm-lc.pdf
> access the page and click "view raw".

This is nicely orthogonal to dm-cache.

dm-cache tries to move a working set of fixed size blocks into a cache
to optimise both read and write.  dm-lc focusses solely on optimising
bursty writes and uses a journal based structure to accomodate
variable sized blocks.

The next step is to get some third party users to post their
experiences with it, and get some feedback on the code itself from
Mike Snitzer.

If I get time I'll integrate it with my test suite.

https://github.com/jthornber/device-mapper-test-suite


- Joe

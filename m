Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaCERpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:45:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbaCERpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:45:21 -0500
Date: Wed, 5 Mar 2014 12:45:03 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: bad rss-counter message in 3.14rc5
Message-ID: <20140305174503.GA16335@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just saw this on my box that's been running trinity..

[48825.517189] BUG: Bad rss-counter state mm:ffff880177921d40 idx:0 val:1 (Not tainted)

There's nothing else, no trace, nothing.  Any ideas where to begin with this?

	Dave


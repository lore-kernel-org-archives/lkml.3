Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3JJSeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:34:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38975 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3JJSeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:34:00 -0400
Date: Thu, 10 Oct 2013 14:33:57 -0400 (EDT)
Message-Id: <20131010.143357.1529669202244130105.davem@davemloft.net>
To: kirill.shutemov@linux.intel.com
Cc: akpm@linux-foundation.org, peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 27/34] sparc: handle pgtable_page_ctor() fail
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381428359-14843-28-git-send-email-kirill.shutemov@linux.intel.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1381428359-14843-28-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 10 Oct 2013 11:34:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Thu, 10 Oct 2013 21:05:52 +0300

> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Acked-by: David S. Miller <davem@davemloft.net>

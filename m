Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaGACP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:15:26 -0400
Received: from one.firstfloor.org ([193.170.194.197]:38582 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaGACPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:15:25 -0400
Date: Tue, 1 Jul 2014 04:15:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] hwpoison: Fix race with changing page during offlining
 v2
Message-ID: <20140701021523.GK5714@two.firstfloor.org>
References: <1404174736-17480-1-git-send-email-andi@firstfloor.org>
 <20140701012146.GA23311@nhori.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701012146.GA23311@nhori.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> Is it -stable matter?
> Maybe 2.6.38+ can profit from this.

Probably not, it's not a critical bug fix.

-Andi

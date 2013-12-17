Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3LQI1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:27:06 -0500
Received: from gloria.sntech.de ([95.129.55.99]:59514 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab3LQI1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:27:04 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree
Date: Tue, 17 Dec 2013 09:26:59 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20131217165956.b5c92af06a83392e8bfb5d46@canb.auug.org.au>
In-Reply-To: <20131217165956.b5c92af06a83392e8bfb5d46@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312170926.59893.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Dienstag, 17. Dezember 2013, 06:59:56 schrieb Stephen Rothwell:
> Caused by commit 34ef6d7fe467 ("rtc: add hym8563 rtc-driver") from the
> akpm-current tree.  Probably some missing include(s).
> 
> I just reverted that commit for today.

The includes are fine, I just seem to have forgotten the dependency of 
COMMON_CLK, which enables the clk structs in clk-provider.h. Sorry about that.

Follow up patch coming shortly.


Heiko

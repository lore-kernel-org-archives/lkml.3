Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab3BTKoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:44:25 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:54517 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab3BTKoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:44:24 -0500
MIME-Version: 1.0
In-Reply-To: <CANZA+xgRWQe2fm8Gok4SxRXEeRU5CztijG4HKNeTDFQfSgHPPw@mail.gmail.com>
References: <CANZA+xgRWQe2fm8Gok4SxRXEeRU5CztijG4HKNeTDFQfSgHPPw@mail.gmail.com>
Date: Wed, 20 Feb 2013 18:44:23 +0800
Message-ID: <CANZA+xgXcwQe8S3+HfaF4QRCTB-XoWS0pvtO4CJT0CT0MMQZqQ@mail.gmail.com>
Subject: What does the PG_swapbacked of page flags actually mean?
From: common An <xx.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PG_swapbacked is a bit for page->flags.

In kernel code, its comment is "page is backed by RAM/swap". But I couldn't
understand it.
1. Does the RAM mean DRAM? How page is backed by RAM?
2. When the page is page-out to swap file, the bit PG_swapbacked will be set
to demonstrate this page is backed by swap. Is it right?
3. In general, when will call SetPageSwapBacked() to set the bit?

Could anybody kindly explain for me?

Thanks very much.

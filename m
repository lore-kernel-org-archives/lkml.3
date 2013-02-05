Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3BEIdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:33:46 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:57801 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab3BEIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:33:45 -0500
MIME-Version: 1.0
Date: Tue, 5 Feb 2013 16:33:43 +0800
Message-ID: <CAFNq8R7_tr_MJmPvzvvHDv05jx6+QVPx8n3U_TA5-yB4bE-chg@mail.gmail.com>
Subject: Qestion about page->_count and page reclaim
From: Li Haifeng <omycle@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all in kernel.

The page->_count is the page frame's usage count. When page is
allocated, the page->_cout will be set 1.

After be allocated from buddy system, the page will be used by
process.  get_page and put_page/put_page_testzero will used in pairs.
is it right?

When the page is reclaimed to buddy system, the page->_count should be
0. However, Because the initialization of page->_count is 1,
get_page() and put_page() is called in pairs, I coufused how
page->_count will be 0?

Thanks.

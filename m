Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab3EGUsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:48:38 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48511 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab3EGUsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:48:36 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 16:48:34 -0400
Message-ID: <CAAVq3rmW=EskLWareDKjwf6BNiFuv=RZiQuZ0jRZfcTkX8+9FQ@mail.gmail.com>
Subject: readahead window size benchmarking
From: yan cui <ccuiyyan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all:

    I am new to the Linux readahead system. After reading the recent
kernel code (3.8.8), I find there is an initial window size decided
based on the read size. And it will increase the window size to a
maximal value (32 pages) if the detected reading is sequential. To me,
the window size seems an important parameter to performance. However,
after testing using some home-made micro-benchmarks, I find that
performance is not sensible to this parameter. So, I wonder to know
what benchmarks (or applications) do you use to test the performance
difference when using different window size? Why not just use the
fixed window size (e.g., 32 pages)?


Thanks,
Yan

--
Think big; Dream impossible; Make it happen.

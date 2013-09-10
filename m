Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3IJM0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:26:19 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:56554 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3IJM0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:26:18 -0400
MIME-Version: 1.0
X-Originating-IP: [72.21.198.64]
Date: Tue, 10 Sep 2013 08:26:17 -0400
Message-ID: <CAO9zADxrPNA8OMLd1NEXgaTnnCoPs0FeVSz2Pf-gOPAppPZ1qw@mail.gmail.com>
Subject: 3.11 kernel: perf samples too long (2501 > 2500), lowering
 kernel.perf_event_max_sample_rate to 50000
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recent upgraded from 3.10 to 3.11 and see these on occasion in the kernel log:

perf samples too long (2501 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000
perf samples too long (5040 > 5000), lowering
kernel.perf_event_max_sample_rate to 25000

I was curious what is causing this/recommendation to fix this problem?

Thanks,

Justin.

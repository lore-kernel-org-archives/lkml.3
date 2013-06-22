Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161610Ab3FVA5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 20:57:34 -0400
Received: from sam.nabble.com ([216.139.236.26]:43881 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161523Ab3FVA5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:57:33 -0400
Date: Fri, 21 Jun 2013 17:57:06 -0700 (PDT)
From: ghostrain <605033747@qq.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1371862626379-672347.post@n7.nabble.com>
Subject: How to get AP tx bitrate from STA side?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there!

I have an AP xmitting data to STA. What I am trying to do is somehow get the
bitrate AP uses for xmission from STA side, which is just like what "iw dev
wlan0 link" does. But I need a kernel function so that I can grab this
bitrate in driver and therefore do some other stuff.

Your suggestions are highly welcome!

Thanks in advance!



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/How-to-get-AP-tx-bitrate-from-STA-side-tp672347.html
Sent from the Linux Kernel mailing list archive at Nabble.com.

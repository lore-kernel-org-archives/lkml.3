Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaFJTwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:52:37 -0400
Received: from mail.datacast.hu ([195.70.49.210]:59874 "EHLO mail.datacast.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306AbaFJTwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:32 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2014 15:52:31 EDT
Message-ID: <53975FF9.5070803@egervary.hu>
Date: Tue, 10 Jun 2014 21:43:53 +0200
From: =?UTF-8?B?RWdlcnbDoXJ5IEdlcmdlbHk=?= <gergely@egervary.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.4.92 MTU issues
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we have just upgraded our systems from 3.4.91 (longterm) to 3.4.92.
Since then we are experiencing dozens of MTU-related network timeout
issues. Reverting back to 3.4.91 fixes all of these problems.

Both kernel versions are built from vanilla sources with the same
.config. These can be highly reproduced over VPN tunnels or even over
simple ethernet connections when using DNAT. (TCP port forward) It
looks like MTU path discovery is somehow affected.

ICMP is not filtered in our network. (For testing, we flushed all
iptables rules, set all policies to ACCEPT, and problem still exists.)
We do not use any special sysctl settings. Was there any changes
related to packet forwarding or MTU discovery?

Thank you in advance,
-- 
Gergely EGERVARY
Network Administrator

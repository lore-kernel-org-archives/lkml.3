Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab3CYWIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:08:42 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53558 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993Ab3CYWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:08:40 -0400
Message-ID: <5150CAE4.1050608@gmail.com>
Date: Mon, 25 Mar 2013 23:08:36 +0100
From: dmitry pervushin <dpervushin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: pablo@netfilter.org
Subject: Android netfilter patches (xt_IDLETIMER) [0/3]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I would like to return to the Android netfilter patches that were posted
in the thread here --
http://article.gmane.org/gmane.linux.kernel/1362838. These patches were
updated according to feedback that John Stultz had received from the list.

So, the first serie of patches is for xt_IDLETIMER.
The first small patches fixes the case when the idle timer has expired
and we refreshing it without any notifications.
The second patch adds capability to send netlink message notifications
in addition to sysfs notifications.
And the last patch is for iptables to use the updated IDLETIMER kernel
module.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaBTVlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:41:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaBTVlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:41:36 -0500
Message-ID: <5306768A.3090602@redhat.com>
Date: Thu, 20 Feb 2014 22:41:30 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: What is the fate of "nohz: Fix racy sleeptime stats" effort?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

I found your posts from last year with patchset
to fix /proc/stats going backwards:

https://lkml.org/lkml/2013/8/16/274
https://lkml.org/lkml/2013/10/19/86

but they did not seem to reach upstream...

What are your plans on them?

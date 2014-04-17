Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaDQVAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:00:46 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:65456 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaDQVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:00:38 -0400
MIME-Version: 1.0
Date: Thu, 17 Apr 2014 23:00:37 +0200
Message-ID: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com>
Subject: inotify, new idea?
From: Jos Huisken <jos.huisken@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to maintain a local and remote directory in sync with
lsync, using inotify.
I happen to have >4M files and >400k directories... running over
/proc/sys/fs/inotify/max_user_watches

What if inotify could just provide all events (limited for instance by
euid), which can be filtered by the application requesting
inotification?
Would something like that be possible?

BTW, I'm not a kernel expert, and not following this list... just
wanted to throw in this idea. Pls Cc: personally.

Thanks,
Jos

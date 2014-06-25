Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaFYS6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:58:37 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:40941 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaFYS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:58:36 -0400
MIME-Version: 1.0
Date: Wed, 25 Jun 2014 12:58:35 -0600
X-Google-Sender-Auth: W2dT0MIXNOsYKRS9vCEN1tOiJho
Message-ID: <CALtpbwjVVyFNOOYHcZw8+WHENoDZKzeZ80MCdNpROzX2mXa0Eg@mail.gmail.com>
Subject: Invalid date in a commit
From: Sasha Pachev <sasha@asksasha.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am looking at

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=12ca45fea91cfbb09df828bea958b47348caee6d

author Daniel Vetter <daniel.vetter@ffwll.ch>2037-04-25 08:08:26 (GMT)
committer Eric Anholt <eric@anholt.net>2009-11-30 17:44:23 (GMT)

Looks like there was a problem with the clock for Daniel. Should that be fixed?

-- 
Sasha Pachev

Fast Running Blog.
http://fastrunningblog.com
Run. Blog. Improve. Repeat.

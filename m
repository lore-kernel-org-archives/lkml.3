Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3JYVBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:01:09 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:42645 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3JYVBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:01:06 -0400
MIME-Version: 1.0
Date: Sat, 26 Oct 2013 01:01:06 +0400
Message-ID: <CAG5DWoj_5cQmQUtd+784sQNW7RhfXUWivP8cbOpADiS1Li35Fg@mail.gmail.com>
Subject: kprobe: "BUG: unable to handle kernel paging request"
From: Azat Khuzhin <a3at.mail@gmail.com>
To: open list <linux-kernel@vger.kernel.org>
Cc: jovi.zhangwei@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With some kernel's configuration there is such messages in dmesg in
different places while using kprobes.

I investigated this and founded that it reproduced with
https://gist.github.com/azat/7078890#file-config-3-12-0-rc5-deb
And not reproduced with
https://gist.github.com/azat/7078890#file-config-3-12-0-rc5-worked-kprobe

I used the next script for testing
https://gist.github.com/azat/7078890#file-ktap-sh

Here is the initial email log with Jovi (ktap author):
http://www.freelists.org/post/ktap/BUG-unable-to-handle-kernel-paging-request-after-ktap-script-to-trace-SyS-write

If I can help, please let me know!
Thanks!

-- 
Respectfully
Azat Khuzhin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaLTCZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 21:25:03 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47735 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaLTCZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 21:25:01 -0500
MIME-Version: 1.0
Date: Fri, 19 Dec 2014 18:25:00 -0800
X-Google-Sender-Auth: y2a19pv7lfzi8IGUtmcdXE--ers
Message-ID: <CA+55aFzktMNKX=9y3iGpf9a7JOH255cfZkxVbmDgUPmABxbxCA@mail.gmail.com>
Subject: Merge window closing..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just FYI - I've got three more pull requests pending (two kbuild ones,
and the READ_ONCE() split-up), and I'll probably delay them until
tomorrow because I have a nasty headache, but I'm planning on closing
the merge window after that.

In other words - if any of you were planning on sending some
last-minute pull requests on the weekend before xmas, you had either
have some seriously good excuses, or you can just say "yeah, they
weren't that critical, I'll do it in a timely manner _next_ merge
window instead".

Just a heads up. You've been warned.

                       Linus

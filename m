Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3IXRlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:41:18 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:33133 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3IXRlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:41:16 -0400
Date: Tue, 24 Sep 2013 20:41:13 +0300
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: fanotify: don't merge permission events
Message-ID: <20130924204113.4621d61a@mdontu-l>
Organization: Home
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, Greg,

Can you pull this[1] patch into your stable kernels (3.2, 3.4)? It
fixes an unfortunate bug in fanotify where a multithreaded application
can end up in an interruptible state, a situation which only a reboot
can fix. Ultimately, I'm hoping that the fix ends up in Ubuntu's
kernels (for which I have also created a request[2]).

Thank you,

[1] https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/fs/notify/fanotify?id=03a1cec1f17ac1a6041996b3e40f96b5a2f90e1b
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1148084

-- 
Mihai Donțu

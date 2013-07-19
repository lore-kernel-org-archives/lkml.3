Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3GSTpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:45:19 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53028 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3GSTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <51E988FF.9010201@nod.at>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com> <51E988FF.9010201@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sat, 20 Jul 2013 01:14:37 +0530
Message-ID: <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With these finishing touches [1], um Linux should work right out of
the box on modern distributions.

Thanks.

[1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html

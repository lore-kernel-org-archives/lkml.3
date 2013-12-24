Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3LXI2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:28:11 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:37806 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3LXI15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:27:57 -0500
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Tue, 24 Dec 2013 12:27:42 +0400
X-Google-Sender-Auth: C_lZFXqusK8WEXjHnF691NQYb4M
Message-ID: <CACaajQv1OWxxcGORBq=LN-4JQzATf4YmWBQymoeyovfY-rUpmw@mail.gmail.com>
Subject: tg3 and sd card reader at acer aspire
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all and sorry for may be spamming mailing list.

I have acer aspire v5-17 with broadcom card reader and ethernet card.
I'm affecting on this ubuntu bugs. But bug is present in vanilla linux
current git and stable lts.

Can somebody helps me and say - where i can post message and discuss
this problem. As i see ubuntu team can't solve this problem (bug
present is about 1 year and nothing changed).
One ubuntu user wia bisecting find broken commit -
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=6cac12dfab9c57a4f76821412224b226a9b08dff

Relevant ubuntu bugs:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1178131
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1067222


Thanks!
-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru

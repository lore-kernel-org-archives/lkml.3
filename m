Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaH3AYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 20:24:34 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52750 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaH3AYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 20:24:33 -0400
MIME-Version: 1.0
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Sat, 30 Aug 2014 02:24:12 +0200
Message-ID: <CAA85sZtQBpOnMh8b-TnFcZsDCp8yViPMyv5jAucB-GNsUvHXYA@mail.gmail.com>
Subject: [Q] threading and scope_process
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have to admit that this is perhaps not the best time to write this,
late in the evening after work but... =)

A friend of mine recently started to develop things on Linux and got a
bit confused since Linux lacks PTHREAD_SCOPE_PROCESS which just about
all other OS:es seems to implement.

(Ok, so I have only googled a bit but it seems like all BSD:s has it
since quite some time and the
same goes for OS X and Windows)

At first i thought that this should be somewhat simple to simulate
using cgroups but there seems to be
quite a overhead and a learning curve, while implementing this should
be simpler because cgroups exist =)

Using this, and thus only compete with your own processes, should make
some multimedia applications
easier to do and could be usable for other things as well, I did talk
to some realtime people a while back
and they were quite surprised that it was lacking...

So, in conclusion is there a reason for this being missing or is it
just a question of "show me the code"?

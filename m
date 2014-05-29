Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaE2PX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:23:57 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:55610 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbaE2PXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:23:55 -0400
MIME-Version: 1.0
From: "Gideon D'souza" <gidisrael@gmail.com>
Date: Thu, 29 May 2014 20:53:35 +0530
Message-ID: <CAPNrq4zJzMwJ2nFwWA3sVc7hr7nYXBRPQomFgZ_1SX+iGxrr0A@mail.gmail.com>
Subject: Pointers on debugging my machine not booting
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys,

So I usually have the latest mainline kernel (on my fedora box) I've
recently sent it tiny refactoring patches.

Today, I start my machine and it just doesn't start. I had 3.11, 3.12,
and a few 3.14 rcs.

All show up booting, a few lines print on the screen about various
things it does. At some random point the screen is just black and
backlit and nothing happens. I tried all kernels, 3.11 and 3.12 and
official fedora supported kernels. The rest I installed. Even the
fedora rescue system doesn't work.

I tried looking into remote debugging linux and keep just getting hits
on virtual machine options. It's time I left my training wheels and I
want to debug my actual machine and see what's going on.

Several of those kernels have debugging support on. I just don't get
what wire I need to buy, what really is a JTAG and I just need a
pointer on how to set it up. I have another windows machine and an OSX
machine around.

Any pointers (pun intended) will be greatly appreciated.

Regards,
Gideon

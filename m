Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945908Ab3AXXSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:18:40 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46303 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3AXXSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:18:33 -0500
MIME-Version: 1.0
X-Originating-IP: [86.16.28.30]
Date: Fri, 25 Jan 2013 00:18:32 +0100
Message-ID: <CAEpun2ZqgWVcVwRwEN6Z0ggmoffhwpcH05EMZ3R5MzYBGAc1nQ@mail.gmail.com>
Subject: My new tool/service - identify unknown kernel source trees
From: Tomasz Mloduchowski <q@qdot.me>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Every now and then I see a tree of kernel sources, contributed in good
faith and compliance with the GPL, by some hardware vendor, or even
worse, a hardware distributor, without any explanation of the changes
made, or even which official tree is it based on.

Usually, some hunting reveals that they branched off the tree
maintained by the SoC manufacturer, and few diffs later, the
investigative part is over.


It had happened for me again, few days ago. I decided to implement a
more automated solution, and I would like to hear your feedback, and
whether (which) kernel trees are notable enough as points of
divergence, to include in this tool.

Before you ask - most of these 'unidentified' sources are lacking git metadata.
Before you ask again - make kernelversion can sometimes reveal what it
is, but only for direct offspring of official trees.


Enough of the introduction, if it's something that you find useful,
please head to:

http://qdot.me/kids


Cheers!
Tomasz

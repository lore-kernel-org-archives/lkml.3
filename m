Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3BELwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:52:05 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50848 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3BELwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:52:04 -0500
MIME-Version: 1.0
Date: Tue, 5 Feb 2013 17:14:58 +0530
Message-ID: <CAK7N6voyvDqWogEWOZFf0e-mQLnoODqxUZr7n=oA-U_z0hLCoA@mail.gmail.com>
Subject: Outdated mbuff driver- update to the latest kernel
From: anish singh <anish198519851985@gmail.com>
To: motyl@sten.chemie.unibas.ch
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel-mail <linux-kernel@vger.kernel.org>,
        stepan@freiburg.linux.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

I have gone through mbuff driver while looking for
this question:how to share large amount of memory
between kernel and user space?

Currently we can do that by mmaping /dev/mem
and /dev/zero but I am looking for something more
simpler(/dev/zero and /dev/mem is using shmem.c-
right now I don't want to dig it) and I think mbuff is
what I was looking for.

I would like to update the mbuff driver to make it
work for the latest kernel as it is using many deprecated
api's.

Is there any place from where I can pick up the latest
version of this driver?

I plan to setup this mbuff driver code in github.

In your mbuff implementation you are using vmalloced
memory but I plan to use get_free_pages just to get
used to using get_free_pages :)

I am sure that this kind of mmaping is already done in
current kernel but this whole exercise is aimed at
understanding it better by actually going through the problems
while implementing.

Hope it makes sense!!
anish

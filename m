Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaJJUZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:25:07 -0400
Received: from mail-wi0-f193.google.com ([209.85.212.193]:64082 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJJUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:25:06 -0400
MIME-Version: 1.0
Date: Fri, 10 Oct 2014 23:25:04 +0300
Message-ID: <CAHno66wDqzNiF1b1ajWWGKTs0kVKH=a6re-WyTnNQRkVySwGzg@mail.gmail.com>
Subject: Re: PROBLEM: ThinkPad Edge: psmouse.c: TouchPad at
 isa0060/serio4/input0 lost sync at byte 1
From: Artem Pylypchuk <articicejuice@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Are you using tleds utility by any chance?
Or any utility that frequently switches keyboard indicators.

I've just discovered that running tleds (for Scroll Lock as eth0
indicator) can cause such problems, on an old MSI MS-171A. It causes
such messages:

psmouse serio4: Touchpad at isa0060/serio4/input0 lost sync at byte 4

 and can sometimes block the keyboard and mouse forever (so you have
to use external USB ones to save your data and reboot).

Anyway, this could also be a hardware problem with the internal serial bus.

Cheers.

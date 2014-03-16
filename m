Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaCPTBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:01:00 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:63072 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaCPTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:00:59 -0400
Message-ID: <5325f4ea.e109350a.0fe4.66f2@mx.google.com>
Date: Sun, 16 Mar 2014 15:00:45 -0400
Subject: Question about futex
From: Ryan Nicholl <r.p.nicholl.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: r.p.nicholl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2GJ18Lx026050

I'm wondering why we have no 64 bit futex? (unless it was added since my kernel.)

I would like to wait on a pointer, right now I have a timeout to avoid deadlock if only the upper half is changed during a race, but this is highly sub-optimal for me.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

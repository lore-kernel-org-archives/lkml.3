Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3GEL4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 07:56:14 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52210 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3GEL4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 07:56:13 -0400
Date: Fri, 5 Jul 2013 19:56:07 +0800
From: majianpeng <majianpeng@gmail.com>
To: tglx <tglx@linutronix.de>
Cc: x86 <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: compile x86_64 waring
X-Priority: 3
X-GUID: 8AA2779A-C0C3-48CA-9C45-851482D3F099
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307051956052638321@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r65BuWnF026598

Hi all,
	Compile x86_64 meet those messages:
WARNING: arch/x86/mm/built-in.o(.text.unlikely+0xbf8): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
The function __node_set.constprop.0() references
the variable __initdata numa_nodes_parsed.
This is often because __node_set.constprop.0 lacks a __initdata 
annotation or the annotation of numa_nodes_parsed is wrong.

WARNING: arch/x86/built-in.o(.text.unlikely+0x171d): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
The function __node_set.constprop.0() references
the variable __initdata numa_nodes_parsed.
This is often because __node_set.constprop.0 lacks a __initdata 
annotation or the annotation of numa_nodes_parsed is wrong.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

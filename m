Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaDEViB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:38:01 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:34623 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbaDEVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:37:59 -0400
MIME-Version: 1.0
Date: Sat, 5 Apr 2014 17:37:58 -0400
Message-ID: <CALKntY1ojYG0U78a36ucgb6L1MZqbthaYidHtsmq1NpnAg1-qw@mail.gmail.com>
Subject: default page size in linux kernel
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What would be the easiest way to modify the Linux kernel to give out
2MB huge pages by default (instead of 4KB) on X86_64 ? Is this
possible without significant changes to the kernel ?

Trent

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaAPHXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 02:23:03 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:59847 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaAPHXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 02:23:01 -0500
MIME-Version: 1.0
Date: Thu, 16 Jan 2014 15:23:00 +0800
Message-ID: <CAK2Ky6x+cLG3SJYWNoM+HVfg9wNRTTDZXaRWJjC6uXp=yH4ocA@mail.gmail.com>
Subject: An error about block I/O subsystem
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have implented an I/O scheduler in Linux 2.6.But when I use fio to
test it,the kernel message often print some words,like this
"deadline_rb: forced dispatching is broken (nr_sorted=1),please report
this"

I have no idea about it,maybe my scheduler has some problems.But I
want to know why!
Thank you!

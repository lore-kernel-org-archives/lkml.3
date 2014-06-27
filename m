Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaF0KNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:13:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44075 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0KNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:13:36 -0400
MIME-Version: 1.0
From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Date: Fri, 27 Jun 2014 12:13:14 +0200
Message-ID: <CAOkSjBjZFhn-m+TVvV=A9FZPuT5h+oLRWUTwOz39tSjxKRN_tg@mail.gmail.com>
Subject: weird oops in kernel/sched/core.c
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there!

It seems I hit a oops in kernel/sched/core.c

This happened in a libvirt/kvm x86_64 virtual machine. I can't get a
complete report, and the virt-manager only let me know the message in
the screenshot [1].

Is a 3.15 based-kernel. No special workload. I was playing with some
Netfilter modules.

Please keep me in CC as i'm not subscribed to the list.

regards.

[1] http://www.anony.ws/i/2014/06/27/oops.png

-- 
Arturo Borrero González

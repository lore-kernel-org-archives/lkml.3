Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3ISO0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:26:22 -0400
Received: from mail-ye0-f176.google.com ([209.85.213.176]:58799 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3ISO0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:26:21 -0400
User-Agent: Microsoft-MacOutlook/14.3.7.130812
Date: Thu, 19 Sep 2013 10:26:17 -0400
Subject: How to duplicate arbitrary process via an LKM
From: Curtis Taylor <yamahabob28@gmail.com>
To: <linux-kernel@vger.kernel.org>
Message-ID: <CE6081C9.31B1%yamahabob28@gmail.com>
Thread-Topic: How to duplicate arbitrary process via an LKM
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm wondering if it's possible to create an LKM that can take an arbitrary
process, removes it from the run queue, duplicates it, and re-runs it with
it's new PID. I would like to see the functionality of a simple user space
fork() but I don't want to edit the application's source code.

I'm new to writing kernel code and after looking at a kernel dev book, it
looks like the system calls clone or do_fork would be what I would leverage
for this. The problem is that clone expects some user space data data in
order to work, but maybe it's possible I could look at the task struct and
figure out everything I need?

Please 'cc' me with responses as I'm not on the mailing list.

Thanks in advance!



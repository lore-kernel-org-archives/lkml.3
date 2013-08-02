Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3HBTHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:07:32 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:44184 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3HBTHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:07:31 -0400
MIME-Version: 1.0
Date: Fri, 2 Aug 2013 12:07:30 -0700
Message-ID: <CABg=H3MScbDmuZgr_Ax3MgEgNjcqN+1vWQ=TjaUisY38XaKnuA@mail.gmail.com>
Subject: debug data for per-cpu variable offsets
From: Deep Debroy <ddebroy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, for x86_64 platforms, I was wondering if there is any table of
per-cpu variable offsets left in a (unstripped) vmlinux file. Looking
at the disassembly of routines accessing a per-cpu variables like
current_task, we see the offset hardcoded e.g. mov %gs:0xc500,%rax. Is
there any table in some section in unstripped vmlinux that indicates
current_task is at offset 0xc500 from gs base (similar to how a
struct's members and offsets are enumerated in the debug sections of
vmlinux)?

thanks,
Deep

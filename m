Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3HWAwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 20:52:22 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:43791 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3HWAwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 20:52:21 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 17:52:00 -0700
Message-ID: <CALCETrUobqJKGCma_8=qsG=w3Tm3=ttZB==DwdHyGBkJDBYV_g@mail.gmail.com>
Subject: Finding out who's holding a lock?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My program is occasionally seeing slow page faults.  latencytop says
they're slow because they're waiting for read access to mmap_sem, but
latencytop isn't showing any other thread in the process blocking.

Is there any straightforward way to find out who called down_write on
mmap_sem when down_read is slow?

--Andy

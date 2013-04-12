Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab3DLQxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:53:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57874 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3DLQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:53:47 -0400
MIME-Version: 1.0
Date: Fri, 12 Apr 2013 11:53:46 -0500
Message-ID: <CAH2r5msLL35BEzzCEcKg1xDBry4MzoDoOjNb78Du7-SugHxYrw@mail.gmail.com>
Subject: [GIT] CIFS Fix
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a regression in cifs in which a password which begins with a
comma is parsed incorrectly as a blank password

The following changes since commit 66ade474237745a57b7e87da9a93c7ec69fd52bb:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
(2013-04-03 16:15:17 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor

 fs/cifs/connect.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

--
Thanks,

Steve

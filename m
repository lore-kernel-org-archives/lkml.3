Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934803AbaFIXLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:11:40 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:58304 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbaFIXLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:11:37 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 9 Jun 2014 16:11:16 -0700
Message-ID: <CALCETrUnV7y7gSk_DStA45xTbCxxD95-x-ON=FS4aMg9czz=WA@mail.gmail.com>
Subject: [GIT PULL] CVE-2014-3917
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is my first pull request.  I may be doing any number of things wrong.]

Hi Linus,

The following changes since commit f2159d1e99612ceb94bf9a2dc2fbca409d828b1b:

  Merge tag 'sound-3.15-rc8' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2014-05-28
11:17:41 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git CVE-2014-3917

for you to fetch changes up to 9fbb05647f3aea17e4e01393bbc42f64ee307409:

  auditsc: audit_krule mask accesses need bounds checking (2014-06-09
16:06:40 -0700)

----------------------------------------------------------------
Andy Lutomirski (1):
      auditsc: audit_krule mask accesses need bounds checking

 kernel/auditsc.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

NB: This is exactly the same patch that's been on the list, except
that I added the CVE number to the description.

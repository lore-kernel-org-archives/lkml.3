Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaFDS1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:27:23 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:51330 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaFDS1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:27:22 -0400
MIME-Version: 1.0
Date: Wed, 4 Jun 2014 11:27:22 -0700
Message-ID: <CAMd89uLDTwQL8rEmAkOSZOYoZgwrcVVTeHDPq5nFnHV+v13cFQ@mail.gmail.com>
Subject: [PERF] TUI bug when interpreting JIT .map files
From: Trevor Norris <trev.norris@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading the .map file for JIT usage in perf report using
the TUI interface there is a specific circumstance where perf
closes almost immediately.

A quick refresher on the contents of the .map file:

<address> <instruction size> <instruction>

The bug is manifested when the same address is listed twice, but
the instruction size differs.

This bug does not occur with the stdio or gtk interfaces.

I plan on attempting to fix this issue. Though my coding chops
aren't yet at par with kernel development. Hence why I post this
now in the case someone else wishes to investigate and is able
to create a patch first.

Please CC me on any response.

/trev
@trevnorris

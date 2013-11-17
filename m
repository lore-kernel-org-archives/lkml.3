Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3KQQWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:22:24 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34231 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3KQQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:22:17 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 0/5] zsh support for perf completion
Date: Sun, 17 Nov 2013 21:43:22 +0530
Message-Id: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.6.gfd75b41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm pleased to announce zsh support for the perf completion script,
added this lazy Sunday afternoon. I'm not very good at shell
scripting, so these patches can definitely use more eyes. Frankly, I'm
mildly surprised that this hack even works: please test carefully and
report bugs.

[1/5] to [3/5] factors things out and prepares the stage for [4/5],
which is the focus of the series. [5/5] is just a pure rename.

Thanks.

Ramkumar Ramachandra (5):
  perf completion: introduce a layer of indirection
  perf completion: factor out compgen stuff
  perf completion: factor out call to __ltrim_colon_completions
  perf completion: introduce zsh support
  perf completion: rename file to reflect zsh support

 tools/perf/{bash_completion => perf-completion.sh} | 100 ++++++++++++++++++---
 1 file changed, 88 insertions(+), 12 deletions(-)
 rename tools/perf/{bash_completion => perf-completion.sh} (65%)

-- 
1.8.5.rc0.6.gfd75b41


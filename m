Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3GDMp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:45:27 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52948 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3GDMp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:26 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] Minor perf completion improvements
Date: Thu,  4 Jul 2013 18:11:24 +0530
Message-Id: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I just started using perf, and noticed the accompanying completion
script. Having dabbled with git.git's completion script a bit, I
thought I should contribute what I learnt from it.

[6/7] is the meat of the series, and the preceding patches work
towards the same goal: to strip dependency on the bash-completion
package.

Thanks.

Ramkumar Ramachandra (7):
  perf completion: don't dictate perf install location
  perf completion: update __ltrim_colon_completions
  perf completion: strip dependency on _filedir
  perf completion: modernize style
  perf completion: strip function_exists ()
  perf completion: strip dependency on bash-completion
  perf completion: use more comp words

 tools/perf/bash_completion | 110 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 87 insertions(+), 23 deletions(-)

-- 
1.8.3.1.643.gebeea52.dirty


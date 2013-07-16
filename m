Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3GPIWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:22:16 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:47556 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab3GPIWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:22:14 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 0/3] ptrace.2: explain new commands to work with signals
Date: Tue, 16 Jul 2013 12:19:30 +0400
Message-Id: <1373962773-2041-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Vagin (3):
  ptrace.2: place GETSIGINFO and SETSIGINFO near each other
  ptrace.2: add description for PTRACE_PEEKSIGINFO
  ptrace.2: add description for PTRACE_{GET,SET}SIGMASK

 man2/ptrace.2 | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 12 deletions(-)

-- 
1.8.3.1


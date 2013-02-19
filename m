Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab3BSGwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 01:52:15 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:50519 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3BSGwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 01:52:13 -0500
Message-Id: <20130219064800.719149796@openvz.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 10:48:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: ebiederm@xmission.com, xemul@parallels.com, hpa@zytor.com,
        akpm@linux-foundation.org
Subject: [patch 0/2] make kcmp own config entry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, kcmp syscall (according to git log) is being wired up for a number
of architectures other than x86 (where it was developed initially). But the
main Makefile which controling its compilation is still x86 dependant.

Thus I think kcmp may deserve own config entry unrelated to arch type it
is being compiled for. In case if some particular arch doesn't support it
ENOSYS should be returned. This small set also wires up kcmp for ARM.

Please take a look, thanks!

	Cyrill

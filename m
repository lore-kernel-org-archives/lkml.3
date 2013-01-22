Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3AVPUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:20:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3AVPUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:20:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: yinghai@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, vgoyal@redhat.com, horms@verge.net.au
Subject: [PATCH 0/2] Only parse exactmap once, introduce memmap=resetusablemap
Date: Tue, 22 Jan 2013 16:20:47 +0100
Message-Id: <1358868049-19884-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is a clean resend of Yinghai's memmap= extensions.
They were discussed on lkml in a thread with subject:
[PATCH] x86 e820: only void usable memory areas in memmap=exactmap case

The patches are based on origin/x86/mm2 where another memmap= 
enhancement from Yinghai is already queued.

Would be great if these can be queued there as well.

Thanks,

   Thomas


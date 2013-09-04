Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab3IDSif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:38:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2112 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759953Ab3IDSid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:38:33 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=VwQbUJbxAAAA:8 a=60Vi2nI6cp0Un2keF0UA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 4 Sep 2013 14:38:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Linux 3.6.11.8
Message-ID: <20130904143832.3287c490@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm announcing the release of the 3.6.11.8 kernel.

I had this tested for a while, just never got around to pushing it. I
may still support a few more releases.

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.8.xz

thanks,

-- Steve

 Makefile                             |    2 +-
 arch/x86/include/asm/irq_remapping.h |    8 ++++++++
 net/core/sock.c                      |    6 +++---
 3 files changed, 12 insertions(+), 4 deletions(-)
---------------------------
Joerg Roedel (1):
      iommu: Fix compile warnings with forward declarations

Steven Rostedt (Red Hat) (2):
      Revert "net/core/sock.c: add missing VSOCK string in af_family_*_key_strings"
      Linux 3.6.11.8

----

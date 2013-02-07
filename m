Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab3BGM45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:56:57 -0500
Received: from mail-ye0-f182.google.com ([209.85.213.182]:53594 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3BGM44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:56:56 -0500
Date: Thu, 7 Feb 2013 07:56:51 -0500
From: Tom Horsley <horsley1953@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG  at net/sunrpc/svc_xprt.c:921
Message-ID: <20130207075651.3016819a@tomh>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed some previous messages with this subject, but the
walkback I'm getting doesn't match exactly the ones shown
in the threads I saw, so I figured I'd send this in.

This happens on both my Fedora 18 and Fedora 17 partitions
when mounting filesystems from very old servers that
need the proto=udp option to talk.

The redhat bugzilla is here:

https://bugzilla.redhat.com/show_bug.cgi?id=908451

There is a photo of the walkback in that bugzilla:

svc_delete_xprt+0x12a
svc_recv+0x101
? nfs_callback_authenticate+0x50
nfs4_callback_svc+0x3b
kthread+0xc0
? ftrace_raw_event_xen_mmu_flush_tlb_others+0x50
? kthread_create_on_node+0x120
ret_from_fork+0x7c
? kthread_create_on_node+0x120

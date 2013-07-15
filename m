Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab3GOQIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:08:32 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:51192 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab3GOQIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:08:31 -0400
MIME-Version: 1.0
From: Ole Tange <ole@tange.dk>
Date: Mon, 15 Jul 2013 18:08:09 +0200
X-Google-Sender-Auth: 9bRPcVTPX84s3z3slSytXf_yrFE
Message-ID: <CA+4vN7ws0vfvFjZCTJPx2kdUtsGPsrNtSbcRM-mVf0S8-b97EA@mail.gmail.com>
Subject: mpt2sas/sd_mod: Adding back a removed disk handle
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of my disks had a slight hiccup. This caused mpt2sas to remove the
handle to the disk. In my kernel log I get:

mpt2sas1: removing handle(0x0021), sas_addr(0x500304800182694c)

By reseating the disk physically I can get mpt2sas to pick up the disk
again, but can I somehow through software ask mpt2sas to detect the
drive again without physically reseating the drive?

I tried:

   parallel 'echo "- - -" >' ::: /sys/class/scsi_host/host*/scan

but that did not pick up the drive.

The drive is sitting in an enclosure
http://www.supermicro.com/products/chassis/4u/847/sc847e26-rjbod1.cfm
connected by http://www.lsi.com/channel/products/storagecomponents/Pages/LSISAS9200-8e.aspx


/Ole
(Please Cc answers - not subscribed to the list)

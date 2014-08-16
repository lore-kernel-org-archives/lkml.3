Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaHPOdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 10:33:53 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:56958 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaHPOdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 10:33:51 -0400
MIME-Version: 1.0
Date: Sat, 16 Aug 2014 10:33:51 -0400
X-Google-Sender-Auth: koyUDLVrFkqPgBrCpLmbQcFoOks
Message-ID: <CA+5PVA4Ld3-VfPN6NWk=uqiuG2p99dL8Ro_X08NFb33_UtnWMA@mail.gmail.com>
Subject: Kernel bug 60770
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Len Brown <len.brown@intel.com>
Cc: ibmalone@gmail.com,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Kernel bug https://bugzilla.kernel.org/show_bug.cgi?id=60770 is marked
as closed, but there is a patch that at least one user seems to need
to get things booting properly.  It was sent upstream a while ago:

http://marc.info/?l=linux-kernel&m=138976439211647&w=2

but has never made it into the kernel.  Do you know why this is or
what happened to the patch?

josh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaA1NG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 08:06:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42657 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaA1NGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 08:06:25 -0500
From: Michel Lespinasse <walken@google.com>
To: Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>
Subject: [PATCH 0/2] Google firmware driver updates
Date: Tue, 28 Jan 2014 05:06:20 -0800
Message-Id: <1390914382-3285-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two small fixes for google firmware drivers.

The patches are against v3.13; I am proposing this for inclusion to v3.14.

Michel Lespinasse (2):
  firmware: fix google/gsmi duplicate efivars_sysfs_init()
  drivers-firmware: google memconsole driver fixes

 drivers/firmware/google/gsmi.c       |  7 ------
 drivers/firmware/google/memconsole.c | 47 ++++++++++++++++++++----------------
 2 files changed, 26 insertions(+), 28 deletions(-)

-- 
1.8.5.3


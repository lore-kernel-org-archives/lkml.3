Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3HAKBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3HAKBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:01:36 -0400
From: Jan Vesely <jvesely@redhat.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Vesely <jvesely@redhat.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology change
Date: Thu,  1 Aug 2013 12:01:29 +0200
Message-Id: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Vesely <jvesely@redhat.com>

These two patches add phy removal on link loss. This change keeps sysfs
up-to-date with actually connected phys. Without these patches,
 disconnected phys remain listed under their former ports.

tested on both mpt2sas and mpt3sas hw.

CC: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
CC: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
CC: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Jan Vesely <jvesely@redhat.com>

Jan Vesely (2):
  mpt2sas: Remove phys on topology change.
  mpt3sas: Remove phys on topology change

 drivers/scsi/mpt2sas/mpt2sas_transport.c |    5 ++++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


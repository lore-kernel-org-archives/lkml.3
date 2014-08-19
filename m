Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaHSEa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 00:30:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60473 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaHSEaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 00:30:04 -0400
Subject: [PATCH v3 0/17] arcmsr: change note since v13 or v2
From: Ching Huang <ching2048@areca.com.tw>
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Aug 2014 12:29:58 +0800
Message-ID: <1408422598.4801.112.camel@Centos6.3-64>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Change note:
1,5,7~17/17 since v1.3 are not change.
2,3,4/17 since v2 are not change.

6/17 since v2:
1. pre-define adapter_type value in private data of pci_device_id.
2. remove the arcmsr_define_adapter_type function.

Ching Huang <ching2048@areca.com.tw>


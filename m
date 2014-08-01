Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaHAILA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:11:00 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37773 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaHAIKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:10:49 -0400
Subject: [PATCH v1.3 0/18] arcmsr: bugfix, new features and support new
 adapters
From: Ching Huang <ching2048@areca.com.tw>
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Aug 2014 16:10:43 +0800
Message-ID: <1406880643.10378.17.camel@Centos6.3-64>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

This patches are made against the git://git.infradead.org/users/hch/scsi-queue.git/tree/drivers/scsi/arcmsr/

This patches series address following issues.

1. Bugfix for command timeout, abort and ioctl error.

2. Add new feature of support MSI-X interrupt and system hibernation.

3. Support new adapters ARC12x4 series.

4. Simplify and unify code for readability and consistency.

Regards,
Ching<ching2048@areca.com.tw>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaEEIc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:32:27 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:36872 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbaEEIcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:32:23 -0400
Subject: [PATCH v1.1 0/16] arcmsr: bugfix and support new adapters ARC12x4
 series
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 May 2014 16:32:15 +0800
Message-ID: <1399278735.18695.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series addresses following issues with arcmsr drivers.

1. Bugfix for command timeout, abort, and ioctl error.

2. Add new feature of support MSI-X interrupt and system hibernation.

3. Support new adapters ARC12x4 series.

4. Simplify and unify code for readability and consistency.

These patched have been compile-tested and running-tested OK.

Regards,
Ching<ching2048@areca.com.tw>


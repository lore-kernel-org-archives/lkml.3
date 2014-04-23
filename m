Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaDWQVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:21:07 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:50871 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbaDWQVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:21:02 -0400
Subject: [PATCH v3] Intel MCH BIOS workaround
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Aaron Lu <aaron.lu@intel.com>, linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Zheng Z Yan <zheng.z.yan@intel.com>,
        Dave Jones <davej@redhat.com>, Rui Zhang <rui.zhang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Date: Wed, 23 Apr 2014 10:20:57 -0600
Message-ID: <20140423161901.16088.46695.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Relative to v2, this adds "#ifdef CONFIG_X86" around the quirk and adds
Stephane's ack.  Either v2 or v3 is fine with me; whatever seems best to
you.

---

Bjorn Helgaas (1):
      PNP: Work around BIOS defects in Intel MCH area reporting


 drivers/pnp/quirks.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

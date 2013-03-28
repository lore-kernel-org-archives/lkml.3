Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3C1E2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:28:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50116 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3C1E2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:28:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Whitehead <mwhitehe@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] eisa: fix eisa with PCI
Date: Wed, 27 Mar 2013 21:28:03 -0700
Message-Id: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like pci eisa bridge support is broken for a while.

one is root io resource reference, and other one is pnp related.

Please check if we can put them in v3.9.
	eisa, PCI: Fix bus res reference
	eisa, PCI: init eisa early before pnp step in

Thanks

Yinghai Lu

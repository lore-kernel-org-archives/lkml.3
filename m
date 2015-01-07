Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbbAGEVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 23:21:53 -0500
Received: from fortimail.online.lv ([81.198.164.220]:47756 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbAGEVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 23:21:51 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 23:21:51 EST
Message-ID: <54ACB0D4.3000008@apollo.lv>
Date: Wed, 07 Jan 2015 06:06:44 +0200
From: Raimonds Cicans <ray@apollo.lv>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0)
 Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Questions about IOMMU & PCIe switch
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
DomainKey-Status: no signature
DKIM-Status: no signature
X-AXIGEN-DK-Result: No records
X-AXIGEN-DKIM-Result: No records
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

We have two kinds of PCIe cards:
A1 - based on chip B
A2 - based on same chip B but behind PCIe switch

Card A1 work flawlessly in any configuration,
but card A2 work flawlessly only if system
lack IOMMU or have disabled IOMMU

Questions:
Do we have to treat card with PCIe switch in special way?
How?
Where (PCI bridge driver? card's driver?)?
Any examples in kernel?

Thank you.

Raimonds Cicans

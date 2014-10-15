Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaJOXog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:44:36 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:34133 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaJOXof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:44:35 -0400
MIME-Version: 1.0
Date: Wed, 15 Oct 2014 16:44:34 -0700
Message-ID: <CA+QbAV6-C9wxPttEx0uDn_K5Y1LaGt8pxDWc8RJmN4DqR+NHtQ@mail.gmail.com>
Subject: PCIe PASID (Process Address Space ID) and iommu code
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending, as message got bounced for html content.
--------------------------------------------
Hi,
    PCIe has introduced PASID TLP Prefix.  There are two ECNs on this.

It seems that AMD iommu code makes use of PASID. Is there a device that
utilizes this TLP prefix?

PASID allocation and management within a device is not clear to me. How
does device know which PASID to issue for which virtual address? Who makes
the association? Must be software/OS, but how? There is no table for this
like MSI-X table.

Any pointer/documentation will be appreciated.

Regards,

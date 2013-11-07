Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3KGIuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:50:08 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64983 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3KGIuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:50:02 -0500
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Nov 2013 14:19:40 +0530
Message-ID: <CABPxzYKNo7rs1TiF=EbQLQpUfuVtJH442eFLqs1Bmz_n_n2Jqg@mail.gmail.com>
Subject: [Query] Using DMA API's with struct dev created from device_create
To: linux-kernel@vger.kernel.org
Cc: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In cases where the BUS interface is system fabric itself,
where no probing is required, so kernel doesn't provide the
"dev" pointer (unlike USB and PCI). The driver is a wireless
driver based on mac80211.

So we used device_create to device, which is passed to
set_wiphy_dev, it works fine.

But when we pass the same device to dma_map_single it
is causing a system panic and reboot (no call stack), instead
if i pass NULL it works just fine.

How do we deal with "struct dev" in such cases?

-- 
Thanks,
Regards,
Chaitanya T K.
P.S. Please CC me to the replies.

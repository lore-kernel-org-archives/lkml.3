Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3GLCFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab3GLCFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:05:04 -0400
Message-ID: <51DF6446.9090105@redhat.com>
Date: Fri, 12 Jul 2013 10:04:54 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: airlied@linux.ie, Vivek Goyal <vgoyal@redhat.com>,
        Baoquan He <bhe@redhat.com>, Chao Wang <chaowang@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: PCIE resetting graphic card
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Takao

I know you are working on the PCIE resetting patches for the iommu kdump
issue.

You explicitly excluded the graphic card in your patch. I have some
questions about this. Why can't we reset the graphic card like other
pcie devices?

We have problems, if 1st kernel is in kms mode kdump kernel will have no
chance to switch back to VGA console. There's no serial port on most of
recent laptops thus it's difficult to debug kdump issue.

So if we can reset graphic card as well, and if it works I wonder if the
2nd kdump kernel can use vga console with nomodeset?


-- 
Thanks
Dave

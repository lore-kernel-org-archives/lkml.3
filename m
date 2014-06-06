Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaFFVNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:13:34 -0400
Received: from mx1.scotdoyle.com ([69.85.92.149]:54695 "EHLO mx1.scotdoyle.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbaFFVNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:13:33 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2014 17:13:33 EDT
Date: Fri, 6 Jun 2014 23:06:33 +0100 (BST)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Benson Leung <bleung@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
cc: Olof Johansson <olof@lixom.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] platform/chrome: Probe multiple i2c adapters of the same
 name
In-Reply-To: <CANLzEkuAxGrRHtb=vFAm9AGws7Qyg3A_oQpAGGFaYEqP2A2g8g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1406062259070.31301@scotdoyle.com>
References: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com> <CANLzEksLB1=+TePxgPRBhsGKpC-4tWB8JOh-Ey80Hj43LkVn=g@mail.gmail.com> <20140604083726.GN1730@lahna.fi.intel.com>
 <CANLzEkuAxGrRHtb=vFAm9AGws7Qyg3A_oQpAGGFaYEqP2A2g8g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would a generalized approach to the "multiple adapters with same name" 
problem be desirable? If so, would this approach work?

I don't have access to an Acer C720. This patch has only been tested on a 
Toshiba Chromebook using the "i2c: designware-pci: Add Haswell PCI IDs" 
patch from Mika applied to the 3.15-rc8 release.

Thanks,
Scot



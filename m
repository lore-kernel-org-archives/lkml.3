Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3LUQuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 11:50:07 -0500
Received: from plane.gmane.org ([80.91.229.3]:57483 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab3LUQuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 11:50:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Holger Freyther <holger@freyther.de>
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on shutdown
Date: Sat, 21 Dec 2013 16:45:17 +0000 (UTC)
Message-ID: <loom.20131221T174326-538@post.gmane.org>
References: <52B31EDA.60908@compulab.co.il> <52B327D5.3080805@compulab.co.il> <20131219182110.GC3573@xanatos> <52B41EC7.1070704@compulab.co.il> <20131220234547.GC2835@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 91.65.247.193 (Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah Sharp <sarah.a.sharp <at> linux.intel.com> writes:

Good Afternoon,


> Also, do you have an HP system, or is this a different vendor?

for what its worth. I do have an Ivybridge laptop and I do see
immediate wake-ups from suspend to ram from time to time. When
this happens I do modprobe -r xhci_hcd and the machine goes to
sleep as expected. This is on an Acer Aspire S5.

holger 


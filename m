Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaLST2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:28:11 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:37019 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaLST2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:28:09 -0500
Date: Fri, 19 Dec 2014 19:28:08 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: sfr@canb.auug.org.au
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: add the omap-pending tree
Message-ID: <alpine.DEB.2.02.1412191715230.3102@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stephen,

Might you be willing to include this branch in your linux-next builds?

git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-pending.git#for-next

It will include OMAP clock, bus architecture, and low-level power 
management patches that are planned to be included in pull requests to the 
OMAP upstream maintainer, Tony Lindgren.  He in turn will submit pull 
requests to the arm-soc tree.  The objective in including this branch is 
to get these patches integration-tested earlier than they would be 
otherwise.


regards,

- Paul

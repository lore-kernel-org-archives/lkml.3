Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBEOAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:00:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaBEOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:00:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
Date: Wed, 5 Feb 2014 15:00:02 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <201402051036.19428.arnd@arndb.de> <52F20732.6070209@monstr.eu>
In-Reply-To: <52F20732.6070209@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402051500.02408.arnd@arndb.de>
X-Provags-ID: V02:K0:1p8QHEsz6QAtWpQ8vDHpJYv8o2ATcK45pujl1EPgIuJ
 GPklTAb3Y6O4/yb1NT89t2ojDhlkK4yeXVSD1ETDJ3Tmjg0e/d
 /uct6qhXMgnbQscDIkFg7YoRysuAgjRQegAwF6kbcymAYlJb0R
 P9JMRd/qxiG6f1+1ARBOnZ4Xu4tqLqtXrCiu4KiuKzblH3iB8f
 XN14licjhAuTVcK61bu7sY9IeGzeWOcgr5mBNF5NEtWJI+954Z
 PADsWQJiNXAa9p+70d4P5Lh5fZdsFDSVbsyC3PY6CU+9WZJ+/+
 uK2vzMmu3vIyM7atjU7mPGnNAGpQNkWxM7CVsHD2/O+6jaGjfb
 PMG/X/Uakfd4JnwHMYP1zSNNxyDQPPH5cei8Q1Yc/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 February 2014, Michal Simek wrote:
> On 02/05/2014 10:36 AM, Arnd Bergmann wrote:
> > On Wednesday 05 February 2014, Michal Simek wrote:
> > Still, the choice of putting the timeout into DT in terms of
> > cycles rather than miliseconds wasn't ideal from an interface
> > perspective and we should change that if/when we do a generic
> > binding. I can definitely see where it's coming from for your
> > case, as the cycle count totally makes sense from an FPGA
> > tool perspective...
> 
> Thanks. I take this like ACK for this current binding description.
> 

Yes, please add my 'Acked-by'.

	Arnd

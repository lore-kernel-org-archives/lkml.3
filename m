Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3FIPQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 11:16:20 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54074 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931Ab3FIPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 11:16:18 -0400
Date: Sun, 9 Jun 2013 17:16:01 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3 05/27] x86, irq: Make dmar_msi/hpet_msi irq_chip name
 consistent
Message-ID: <20130609151601.GB2245@breakpoint.cc>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
 <1370644273-10495-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370644273-10495-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:30:51PM -0700, Yinghai Lu wrote:
> All others are using "-" instead of "_".

Who are "all others"? According to my grep it is 121 vs 44. So even without
your two here we still 42 doing it the other way around so it is not all.

However it might make sense to use _ instead of " " within a chip's name and
- as a delimiter for modes like edge or level. However that is way beyond the
scope of this patch and I am not sure if anyone finds this usefull at all.

Saying this, I am fine with this patch :)

Sebastian

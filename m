Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579Ab3LIVHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:07:40 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:10739 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761540Ab3LIVHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:07:34 -0500
X-IronPort-AV: E=Sophos;i="4.93,860,1378882800"; 
   d="scan'208";a="1071641"
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: Michael Chan <mchan@broadcom.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Natarajan Gurumoorthy <natg@google.com>, <nsujir@broadcom.com>,
        <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <52A633B4.9000307@cogentembedded.com>
References: <1386614601-9453-1-git-send-email-natg@google.com>
	 <1386615608.1752.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <CAGmqidkxoi9EEe0uC18QQUXwjFP1e_1MXL7VPk+NtU-Ta6FGUg@mail.gmail.com>
	 <52A633B4.9000307@cogentembedded.com>
Content-Type: text/plain; charset="cp1252"
Date: Mon, 9 Dec 2013 13:07:33 -0800
Message-ID: <1386623253.1752.6.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 00:18 +0300, Sergei Shtylyov wrote: 
> >        We had crashes when the PCI config space got scanned via
> > /sys/devices/pcixxxx/....../config.
> 
> > I agree that this fix will not help if the scan happens before the tg3
> > driver gets loaded.
> 
>     Then perhaps a better place for such fixup would be a PCI quirk?
> 
Yes, I agree.  Thanks.


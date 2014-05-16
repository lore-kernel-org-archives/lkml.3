Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbaEPOup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:50:45 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:58914 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757109AbaEPOun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:50:43 -0400
Message-ID: <1400251841.20342.50.camel@x220>
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 May 2014 16:50:41 +0200
In-Reply-To: <20140516125545.GO3693@n2100.arm.linux.org.uk>
References: <1364507176.1345.45.camel@x61.thuisdomein>
	 <8309592.drxAj71PnZ@wuerfel> <1400059550.31197.12.camel@x220>
	 <4305975.PvMXZQ020k@wuerfel> <1400232598.20342.16.camel@x220>
	 <20140516125545.GO3693@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2014 14:50:41.0387 (UTC) FILETIME=[354383B0:01CF7116]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 13:55 +0100, Russell King - ARM Linux wrote:
> There was a CPU called the ARM710, it was ARMv3 and it had no Thumb support.
> 
> There is also a CPU called the ARM710T, which is ARMv4 and has Thumb support.
> 
> These are two completely different CPUs, the former was removed along with
> the removal of ARMv3 support.  The latter remains because we still support
> ARMv4.

Thanks for taking the time to explain this. Next time I hope to be more
aware of the possibility of important differences between ARM CPUs that
have rather similar names.


Paul Bolle


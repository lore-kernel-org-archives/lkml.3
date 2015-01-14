Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbbANJ3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:29:04 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60727 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbbANJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:29:00 -0500
Message-ID: <1421227738.15397.46.camel@x220>
Subject: Re: clocksource: marco: CONFIG_ARCH_ATLAS7?
From: Paul Bolle <pebolle@tiscali.nl>
To: Barry Song <Barry.Song@csr.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Jan 2015 10:28:58 +0100
In-Reply-To: <5EB3BFCD089AD643B9BB63439F5FD5E90177A62F01@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1421225516.15397.41.camel@x220>
	 <5EB3BFCD089AD643B9BB63439F5FD5E90177A62F01@SHAASIEXM01.ASIA.ROOT.PRI>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2015 09:28:58.0801 (UTC) FILETIME=[8667E210:01D02FDC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-14 at 09:21 +0000, Barry Song wrote:
> > -----Original Message----- 
> > Your commit 81428bbe1d8a ("clocksource: marco: Rename marco to
> > atlas7") is included in today's linux-next (ie, next-20150114). I
> > noticed because a script I use to check linux-next spotted a
> > problem.
> > 
> > See, your commit renames one reference to CONFIG_ARCH_MARCO to
> > CONFIG_ARCH_ATLAS7. But there's no Kconfig symbol ARCH_ATLAS7 in
> > linux-next yet. I assume that one or more patches to add ARCH_ATLAS7
> > (or to rename ARCH_MARCO to ARCH_ATLAS7) are queued somewhere. Is
> > that correct?
> > 
> Yes, paul.
> It is queuing in arm-soc for refining my pull-request. Related patches
> have been acked by Arnd.

Unless the related patches take a long time to land (say, until after
v3.20-rc1) I won't bother you again about this.

Thanks!


Paul Bolle


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbbALMcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:32:11 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:63263 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbbALMcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:32:09 -0500
Message-ID: <1421065927.22660.61.camel@x220>
Subject: Re: MIPS: ralink: CONFIG_SOC_RT2880?
From: Paul Bolle <pebolle@tiscali.nl>
To: John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2015 13:32:07 +0100
In-Reply-To: <1414404391.28499.10.camel@x220>
References: <1414404391.28499.10.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2015 12:32:07.0887 (UTC) FILETIME=[C795D5F0:01D02E63]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Mon, 2014-10-27 at 11:06 +0100, Paul Bolle wrote:
> Your commit 0b162e003c2c ("MIPS: ralink: add rt2880 pci driver") landed
> in today's linux-next (ie, next-20141027). It adds a check for
> CONFIG_SOC_RT2880. But there's no Kconfig symbol SOC_RT2880.
> 
> Did you perhaps mean CONFIG_SOC_RT288X here?

This too ended up in v3.19-rc1 and later. There's still no Kconfig
symbol SOC_RT2880 and therefor arch/mips/pci/pci-rt2880.o will never be
built. Can someone please look into this?

Thanks,


Paul Bolle


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbbALMf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:35:56 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55192 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbbALMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:55 -0500
Message-ID: <1421066153.22660.64.camel@x220>
Subject: Re: MIPS: ralink: CONFIG_SOC_MT7621?
From: Paul Bolle <pebolle@tiscali.nl>
To: John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2015 13:35:53 +0100
In-Reply-To: <1414406687.28499.17.camel@x220>
References: <1414406687.28499.17.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2015 12:35:54.0117 (UTC) FILETIME=[4E6DCB50:01D02E64]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Mon, 2014-10-27 at 11:44 +0100, Paul Bolle wrote:
> Your commit 715f2e581856 ("MIPS: ralink: cleanup early_printk") landed
> in today's linux-next (ie, next-20141027). It adds two checks for
> CONFIG_SOC_MT7621. The patch to add Kconfig symbol SOC_MT7621 is still
> pending (see http://patchwork.linux-mips.org/patch/8033/ ).
> 
> Obviously, until that patch lands these two checks will always evaluate
> to false.

These useless checks have now made it into v3.19-rc1 and later. What's
the current status of the patch I quoted above?

Thanks,


Paul Bolle


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3HTSNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:13:17 -0400
Received: from void.printf.net ([89.145.121.20]:58232 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab3HTSNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:13:14 -0400
From: Chris Ball <cjb@laptop.org>
To: monstr@monstr.eu
Cc: James Walmsley <james@fullfat-fs.co.uk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Subject: Re: SDHCI - Add QUIRK2_BROKEN_WRITE_PROTEXT - Support Xilinx Zynq (Linux 3.9.0)
References: <BEDA323D25EF6045A68DAB9FD91A0BF14A5E84DB@AMSPRD0411MB426.eurprd04.prod.outlook.com>
	<521366EA.7080705@monstr.eu>
Date: Tue, 20 Aug 2013 19:13:11 +0100
In-Reply-To: <521366EA.7080705@monstr.eu> (Michal Simek's message of "Tue, 20
	Aug 2013 14:54:02 +0200")
Message-ID: <86li3wdydk.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 20 2013, Michal Simek wrote:
> Hi James,
>
> isn't it better to implement host->ops->get_ro() function for it?
> It seems me better choice than introducing new quirk option.

Yes, I agree.  Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>

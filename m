Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaLDQLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:11:12 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:60195 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbaLDQLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:11:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: suravee.suthikulpanit@amd.com, mark.rutland@arm.com, will.deacon@arm.com,
        marc.zyngier@arm.com, catalin.marinas@arm.com, liviu.dudau@arm.com,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH 2/2] arm64: amd-seattle: Fix PCI bus range due to SMMU limitation
Date: Thu, 04 Dec 2014 17:10:52 +0100
Message-ID: <2035567.rcXVTvDFpt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417405600-19232-3-git-send-email-suravee.suthikulpanit@amd.com>
References: <1417405600-19232-1-git-send-email-suravee.suthikulpanit@amd.com> <1417405600-19232-3-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:f0sOXVaoHuXf+BMagYfq3fSZadhwHml3dWtAyIew/JP5lTTPQVE
 0wUhauRp/9sABK9pgv41TQSjVHAYBEdzgt7aobSQdyryBly8XCWSGYtp8s4+ljOtFP5zuBK
 sWSq4qAFwmkslu8Rw8UsVeJuOslSaXBrQJKlPhRWc4JnMtJNXDdOAiP+T/8AIDlvvnihtyc
 fFia8FUcg4KTl71EYCceQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 November 2014 21:46:40 suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Since PCIe is using SMMUv1 which only supports 15-bit stream ID,
> only 7-bit PCI bus id is used to specify stream ID. Therefore,
> we only limit the PCI bus range to 0x7f.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 

Applied the second patch, thanks!

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaCSSiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:38:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaCSSiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:38:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Date: Wed, 19 Mar 2014 19:37:51 +0100
Message-ID: <8312584.jdZZuHGAjg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140319172140.GA16328@e106497-lin.cambridge.arm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com> <20140319135619.GC6231@localhost> <20140319172140.GA16328@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VRH170iob5B36FuKJ1RDIPQn5u6i7f6povZtOKaFNlD
 WLclroYZD55xJ2ne/ZDjQ4LHlQOJ+0xgjpy1+E2qoBHlxZY6en
 s8bpXYX8n189BxE0yrTWWqkY/euIGv7E2ZP3tenLkS8ZmlZ0ru
 vuZ4H4h6TueQ60LCuwgDuycqiErFyO/aKru0TnBjly1IKPhsbF
 Wz0oP6HF0ptLyZCWdNXDS68s/BGNdzuvhuDyBlAIkd2Sa4iTCS
 cy+qcKVgwLgzkBc5NMPlg6foMLuLkjgRqztuOqcTBTVsR5CVZ0
 Ft4XXP6KCfL9lrCkxzktzBimhItuo0kwMM3J1RkQTukfAsD1G4
 cLtzYNRfh0XnQ179iFXg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 March 2014 17:21:41 Liviu Dudau wrote:
> 
> My ultimate point is that no matter how long we argue about the shape of the functions that
> I've added into arch/arm64/kernel/pci.c I don't think we can get away without having that
> file, or at least not in the first phase if we want speedy integration into mainline.

Let me simplify the discussion here:

NAK to adding yet another architecture specific implementation.

	Arnd

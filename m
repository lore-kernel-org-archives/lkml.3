Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbbAKPuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:50:35 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:55484 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbbAKPud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:50:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/8] ARM: Conexant Digicolor CX92755 SoC support
Date: Sun, 11 Jan 2015 16:49:57 +0100
Message-ID: <2596137.dsVM7gCxOQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150111113327.GQ2481@sapphire.tkos.co.il>
References: <cover.1420744368.git.baruch@tkos.co.il> <5966468.GiJYdzCvnt@wuerfel> <20150111113327.GQ2481@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:3Aosm1/DGw4coGxfLrRpmbfcpEZNa88Xs7fKr13bwDrJIXGzF8F
 L0xhuHWdZxeNXSgoKJ3vbA1gkaYi8GkeFxiihl4U02qgMECvX5pI2HE0U28REDzn4EPYf78
 Zpqi16lvpuks17oGXprHaWKTB07QjhIgz1OAHAWwT3q3S+P3MQ7dvEJSAgljfOPsSQnxKlL
 /HBYJmbxzvLISwFujzEtQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2015 13:33:27 Baruch Siach wrote:
> > Once there are no more review comments, please submit the first three
> > patches to arm@kernel.org, and send the other patches as separate
> > series to the respective maintainers for irqchip and clocksource.
> 
> What about the last patch in this series (ARM: devicetree: document supported 
> Conexant Digicolor SoC)? What tree should it go through.

That can go along with the first three patches for the platform.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaLAQR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:17:57 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:61192 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaLAQRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:17:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Mon, 01 Dec 2014 17:17:30 +0100
Message-ID: <2417519.MDE3mu6n7n@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141201115006.08197c40@bbrezillon>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <19172687.eVxczUuuhC@ws-stein> <20141201115006.08197c40@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T1OqJCtf925Nfvt9RxOFvE80Pz2BXm23zAKSK78qrxg
 80XBNe3ukydnuFLV+PJBMQhmkFLckWHPE3QkV6qnI6yJtH0n4U
 ZfHDRUGTRdcMXADJPUn+VthVd+U6kZsbfDUdOXRWvD5Xyp7S3P
 mh9l6smsbOEYojFd89ReVoOxFEWw/rZpmUiv9yeb95kB42F0uK
 gV1ji3eQXUfH06qcvCY82cJRqjuEPky/IHD1foE3lCAbyZFkuZ
 0kUQho13efUW4huxNQ3e7Gv8fkAJhDbcM9s4d3xWNyTSTRb45D
 GvLiFIEAHevqvPJ5TTjhRaWV/hU3gLk9y0zqurzXApbeSriuDZ
 lNXUc3yr7nHbAMYMewJM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 11:50:06 Boris Brezillon wrote:
> 
> I don't have a strong opinion regarding where this driver should
> live (I even considered putting it in drivers/bus) :-).
> But note that there are other "external memory interface" drivers
> in drivers/memory too: TI AEMIF and Marvell DEVBUS  ;-).
> 
> Does anyone else think this driver should go in drivers/bus ?
> 

I think drivers/memory is better.

	Arnd

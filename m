Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaABU0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:26:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaABU02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:26:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] tty: serial: Limit msm_serial_hs driver to platforms that use it
Date: Thu, 02 Jan 2014 21:26:02 +0100
Message-ID: <1877300.Iu7OMicvV0@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52C5CA05.5080803@codeaurora.org>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org> <201401021910.22651.arnd@arndb.de> <52C5CA05.5080803@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MT+hjgmaJz7KHqGjgBs6QlsCtM27STTmjlr6OKN1h0a
 gWRV4LLExYUc5RrYRXQGNAbtqtT81+1Skd+oNEa1pBLzPSa+Jw
 uaZrytvs8NN6qLZ1hDL0aiurssRaT+d8HTIEFv6Y2qT0LkS1ua
 fiXK0oUdM1sbWz/1+h/CJZJtGGugxI3sMKjQZ7W47COshXHKc7
 knX9r6RL09vhvy4CdYr+4OltTo3/QH1SuKis09BES5jIEZ9QIy
 p7QXvClN94rowXrRAzFEaSQHqimv3bRa2Bkbm89v9Xez8IBG2r
 pgMGGTRQ2m9pPYvgj5BUrDUlUuXcu50zXFGoq9tinr3QdJ5Zlx
 Xl8pTDKMZVZbJ0u3CN9s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014 12:20:21 Stephen Boyd wrote:
> Yes, we plan to add the code for dma based serial devices into the
> msm_serial.c driver. In the process we'll use the linux DMA apis instead
> of using mach specific ones.

Ok, very good.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3HFSm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:42:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab3HFSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:42:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v8] dmaengine: Add MOXA ART DMA engine driver
Date: Tue, 6 Aug 2013 20:42:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, vinod.koul@intel.com, djbw@fb.com,
        linux@arm.linux.org.uk, mark.rutland@arm.com
References: <1375713457-5562-1-git-send-email-jonas.jensen@gmail.com> <1375792711-21853-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1375792711-21853-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308062042.13809.arnd@arndb.de>
X-Provags-ID: V02:K0:9iIplspjpaFgOz6NjMFN8EVIhL6w4ezctQYDyU7mHMN
 QYO8y8SWujqodXQE5sLyNni8l8cPL5hbbJbTFQdS2XiJjq9521
 ++PlKIxr2VBswDAp1kkKNdcpQkhla+5MyExKvUpngNIhhkRe2o
 qPQBZ/o0U77cehAeCTlQuOLEDsNgQDPCwvTOxRQFNugA7ZFdsi
 Ow1nr8BMGFay35No4IJG3IrmBYrwDpeeHMF+E8NWufpXaIWed3
 XGHsn3DlpSpEp4GDvQCylYVWTIJN6KJ2geIZ2Ki6VIAAPGHYTs
 vZYCrE7Q5ocyXT5t91uqFMlK/r7sOwfvidTSzRrcil2uE0yYSS
 xGRbwexHagHOZmLIgiO0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 August 2013, Jonas Jensen wrote:
> The MOXA ART SoC has a DMA controller capable of offloading expensive
> memory operations, such as large copies. This patch adds support for
> the controller including four channels. Two of these are used to
> handle MMC copy on the UC-7112-LX hardware. The remaining two can be
> used in a future audio driver or client application.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Looks all good to me now,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaDWMf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:35:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:61881 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaDWMfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:35:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 7/7] ARM: sun6i: dt: Add A31 DMA controller to DTSI
Date: Wed, 23 Apr 2014 14:35:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, andriy.shevchenko@intel.com,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        dmaengine@vger.kernel.org
References: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com> <1394723659-4995-8-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1394723659-4995-8-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231435.03920.arnd@arndb.de>
X-Provags-ID: V02:K0:kMC2r0yQibEezCE3SSbhiFkIHFIoSUNm5VhuMn2OoZj
 vxUfA+JK1zZzxU7FrkbWj3IZkKdzgJ3Wb7JmrJiaTaieq7FW9q
 Get2vNHvCPmzjjvSEw0sojZlvHFLMmI15CfMMwlY0JSLVB7jNm
 nwON1v9bFKRJdq7WEV4MR5b6lcb97tIULPb2GRykUUCHiN53uE
 dSzZ5eQyDWmoF9Xjn7Wg2JfL27lBZLMDIGDC3fMl4WGOaHyW2h
 9U5nvh9meG4RQBHTLeGGpzTFsMheLjbfgUlHkXLvRy3uwNl+ut
 RFQRX+f2IRm+aXqLEpi8EYiedAm90/qQ2nAsBH+cWUlQrTc3u+
 UMTVIS1cJPg5UlnkC3WM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2014, Maxime Ripard wrote:
> Now that we have a DMA driver, we can add the DMA bindings in the DTSI for the
> controller and the devices supported that can use DMA.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

But why does this patch have to wait for the driver to get merged?

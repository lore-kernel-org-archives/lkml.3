Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3IYMRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:17:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50487 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3IYMQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:16:59 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-e6-5242d43a0edf
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Tejun Heo <tj@kernel.org>, Roger Quadros <rogerq@ti.com>, balbi@ti.com,
        bcousson@baylibre.com, tony@atomide.com, balajitk@ti.com,
        kishon@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
Date: Wed, 25 Sep 2013 14:16:41 +0200
Message-id: <2926093.ynDRy1bx5J@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <524039E0.2060205@cogentembedded.com>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
 <20130922215107.GD27616@mtj.dyndns.org> <524039E0.2060205@cogentembedded.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+xoK7VFacggx1LFSymTt7OZnHwfr3F
	nfl/WS3mHznHanHhaQ+bxabH11gtju14xGRxedccNovZS/pZLHoeaVmcWXWL3eLX8qOMFvuv
	eDnwenz7OonF4/2NVnaPB1P/M3lsWtXJ5rF5Sb3H8RvbmTw+b5ILYI/isklJzcksSy3St0vg
	yuhf3cRWcJSt4veVuywNjL2sXYwcHBICJhLPrkZ2MXICmWISF+6tZ+ti5OIQEpjOKDHx9jso
	p4VJ4sbboywgVWwCVhIT21cxgtgiAhYSdxsXsYAUMQtsYpLoudrBBpIQFnCSWLD3OlgDi4Cq
	xK4nr8FsXgFNiacnnrGD2KICnhKfJi1lBrE5BYwkVt9oYYfY1ssoce3yAyaIBkGJH5PvgTUz
	C8hL7Ns/lRXC1pHY3zqNbQKjwCwkZbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5y
	fu4mRnDEPJPawbiyweIQowAHoxIPr8BRxyAh1sSy4srcQ4wSHMxKIrzhi52ChHhTEiurUovy
	44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTCmnv+Ve/FJnE2hE59o69m3
	Znzeae+D2rbzKnBkHpwxoUWH6dNUn+s1oQrh//VWfL0XqzHnyWnRoBT3WfK6yc+OunNt7rDN
	N5htNWvai3M7RCQ1OJ8stNwcneQb8XJxbWT1xqsWR+cJHtvslciwgOHyVC6mKa26T6ZPqY4M
	KFbUcn0SwcvxbYsSS3FGoqEWc1FxIgCgJuYXlAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, September 23, 2013 04:53:52 PM Sergei Shtylyov wrote:
> Hello.
> 
> On 23-09-2013 1:51, Tejun Heo wrote:
> 
> >>     Not sure why you asked -- I'm not using this driver, neither I'm
> 
> > Well, you have better grip of what's going on in the embedded world
> > than me.  I'm mostly curious whether adding dependency on PHY is okay.
> 
>     This driver already supports optional clock, the optional PHY support
> seems analogous.

Right, this reminds me that PHY support should probably also be added to
ahci_suspend() and ahci_resume().

Also please note the generic PHY framework is not yet merged in Linus'
tree so this patch should probably be merged only after the generic PHY
framework is in.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


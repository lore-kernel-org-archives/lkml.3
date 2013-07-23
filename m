Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab3GWLoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:44:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59822 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab3GWLoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:44:37 -0400
From: "Abraham, Tobin" <t-abraham@ti.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>
Subject: RE: [PATCH 0/5] Davinci VPBE use devres and some cleanup
Thread-Topic: [PATCH 0/5] Davinci VPBE use devres and some cleanup
Thread-Index: AQHOh5Zuuwzt0er5dk2aXgPVhSoyb5lyJJFA
Date: Tue, 23 Jul 2013 11:44:34 +0000
Message-ID: <A3C3B419C9045B40BA472523342D9C69C7ED31@DFLE10.ent.ti.com>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
 <CA+V-a8ue48_p1ysK+H3i5i_P29KTESxX2U-SU1frcyvGRLn8wQ@mail.gmail.com>
In-Reply-To: <CA+V-a8ue48_p1ysK+H3i5i_P29KTESxX2U-SU1frcyvGRLn8wQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I do not know why I keep receiving these e-mails from multiple people. Could you please remove me from your e-mail lists?

Thanks!

-Tobin Abraham

-----Original Message-----
From: davinci-linux-open-source-bounces+t-abraham=ti.com@linux.davincidsp.com [mailto:davinci-linux-open-source-bounces+t-abraham=ti.com@linux.davincidsp.com] On Behalf Of Prabhakar Lad
Sent: Tuesday, July 23, 2013 6:18 AM
To: Hans Verkuil
Cc: DLOS; LKML; LMML
Subject: Re: [PATCH 0/5] Davinci VPBE use devres and some cleanup

Hi Hans,

On Sat, Jul 13, 2013 at 2:20 PM, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch series replaces existing resource handling in the driver 
> with managed device resource.
>
> Lad, Prabhakar (5):
>   media: davinci: vpbe_venc: convert to devm_* api
>   media: davinci: vpbe_osd: convert to devm_* api
>   media: davinci: vpbe_display: convert to devm* api
>   media: davinci: vpss: convert to devm* api

can you pick up patches 1-4 for 3.12 ? I'll handle the 5/5 patch later.

Regards,
--Prabhakar Lad
_______________________________________________
Davinci-linux-open-source mailing list
Davinci-linux-open-source@linux.davincidsp.com
http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source

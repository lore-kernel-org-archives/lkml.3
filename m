Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaBQGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:09:28 -0500
Received: from nm8-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.95]:36794 "EHLO
	nm8-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbaBQGJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:09:24 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 01:09:24 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s1024; d=yahoo.com.au;
	b=QnRSbC9iyuWRKivxQVTXN0UYQ85GcFWA3KgtNtLlbCkRjPt4IyWg9ANmvLkujmcdhg0AtOPrhlo9Zu6P/uak0Ki2TyznKLR4Qj5P0oIKlDu4HKIzum3M5p9as72LD49UQZhZou51tl0C2IDfyc0jMn8pZmxbVu0g8rFUh9tfIZs=;
X-Yahoo-Newman-Id: 65435.7593.bm@smtp228.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GYWy5dkVM1mgWagrc.wbkVe_NpPE3sxT7K5OKUmH1hqxMF5
 TI5xqrCK9hAEyicHGQVDcVD.YAefNXcW79K5olkIdgFUmGiyZiSRZSuMaooB
 4KaEmqi5me9FIoT6z2hKoz2qR58i9FORkQjIp1CgJxHynl1frIcLx1GH5UAs
 NU6w.OwZrB6J2dgPYoa1lZUVTxYVedGnRX1FPdiUqjfF_3kMf1AnV0LMmZ1z
 V02VXEy1PVTtS5Dy_ijxdQOJSJYmOvdKNX0V.6z0D5LeW8DPcW57D_3C13iU
 8oqOWrtj95Z_G1e_bgVzfw2dFWSkU2G22mzPmJaBUHEmX3FKCS.untrYHyEj
 KVShS_java6gVHUOvzTq4_GAUFE2RDMbmK61sjsxoHvLzFPHjNGjgOtXLNxY
 9LbCaXHGP_94YhxXIXRoXT70.ugaXVuJkMLyjzzKZ.7KD9EtIDtre1EhEwEw
 XL18QBIpwD.PaXy3ZLEFHSeNgqxH__QQu.JrqNbr9LiujZ_KToznRBIkwJGL
 gVzyNEI1UCcy_GS9HN3cCNcoDuuZYEBmW_NPpeZuqut8Hw0zWP0Y5
X-Yahoo-SMTP: HRQj2fWswBBC5fErUYxVDeLCn8s-
X-Rocket-Received: from desktop-fedora.coffee.gen.nz (slapdau@121.74.111.210 with plain [63.250.193.228])
        by smtp228.mail.bf1.yahoo.com with SMTP; 17 Feb 2014 06:04:06 +0000 UTC
Message-ID: <5301A64F.2090205@yahoo.com.au>
Date: Mon, 17 Feb 2014 19:03:59 +1300
From: Craig McGeachie <slapdau@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        courtney.cavin@sonymobile.com, rafael.j.wysocki@intel.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv3] Generic Mailbox API
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
In-Reply-To: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/02/14 07:22, Jassi Brar wrote:
> Hello,
>
>    Here is what the generic mailbox api looks like after modifications
> to make it work with 5 different platforms.
>   Major feedback from Suman Anna(TI), LeyFoon Tan(Intel),
> Craig McGeachie(Broadcom) and Loic Pallardy(ST).
>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>

Um, sorry for not having included this in the previous email.  I've just 
looked over the patch set and I don't believe it contains anything that 
I did, so I don't think my name is appropriate here at all.

Cheers,
Craig.


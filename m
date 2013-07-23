Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3GWPBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:01:17 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:57764 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab3GWPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:01:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130723162659.5aa59750@tux.DEF.witbe.net>
References: <20130611123814.GA9854@lnx-rg> <20130626142241.GA13107@lnx-rg>
 <51CB0E9C.50408@lwfinger.net> <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
 <20130723142907.53103aab@tux.DEF.witbe.net> <20130723162659.5aa59750@tux.DEF.witbe.net>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 23 Jul 2013 17:00:54 +0200
Message-ID: <CACQ1gAiyc6e39S8FnjTE7GX7SeorHjJP6gLZGRWsgi8f1zjEaw@mail.gmail.com>
Subject: Re: rtl8192cu: slow path warning
To: Paul Rolland <rol@witbe.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/23 Paul Rolland <rol@witbe.net>:
> Hello Richard,
>
> If you still have the required HW and still would like a patch to remove
> that warning on your machine, could you please try the attached one ?
>
> I slightly reworked the original patch by moving the function
> rtl_lps_change_work_callback from pci.c to ps.c.
>
> I've successfully compiled that on my machine, but I have PCI set in
> my .config, so I'd like your feedback.
>
> Best,
> Paul

Hi Paul,

Well, I don't know why this patch didn't make it to 3.11-rc1, but it
seems that the patch you sent is the same as Larry's second patch :
https://lkml.org/lkml/2013/6/27/548

Best regards,
Richard.

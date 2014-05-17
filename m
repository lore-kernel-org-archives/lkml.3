Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaEQLgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 07:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbaEQLgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 07:36:38 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Larry.Finger@lwfinger.net, navin.patidar@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] staging: rtl8188eu: fix Coverity defects in rtw_drv_init()
References: <1400323138-32243-1-git-send-email-cengelma@gmx.at>
Date: Sat, 17 May 2014 13:36:26 +0200
In-Reply-To: <1400323138-32243-1-git-send-email-cengelma@gmx.at> (Christian
	Engelmayer's message of "Sat, 17 May 2014 12:38:56 +0200")
Message-ID: <wrfjsio8tz5x.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Engelmayer <cengelma@gmx.at> writes:
> This addresses two issues currently reported by static analysis for function
> rtw_drv_init() in drivers/staging/rtl8188eu/os_dep/usb_intf.c.
>
>    CID 1077553 - Logically dead code
>    CID 1077832 - Uninitialized scalar variable
>
> Compile tested only. Applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>
> Christian Engelmayer (2):
>   staging: rtl8188eu: fix usage of uninit scalar in rtw_drv_init()
>   staging: rtl8188eu: remove dead code in rtw_drv_init()
>
>  drivers/staging/rtl8188eu/os_dep/usb_intf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

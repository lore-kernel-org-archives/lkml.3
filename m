Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaBMXVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:21:09 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:42871 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBMXVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:21:07 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-87-52fd53621905
Date: Fri, 14 Feb 2014 08:20:59 +0900
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] MAINTAINERS: Add Mauro and me as interim patch collectors
Message-id: <20140214082059.179c283a.m.chehab@samsung.com>
In-reply-to: <1392327316-15789-1-git-send-email-bp@alien8.de>
References: <1392327316-15789-1-git-send-email-bp@alien8.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/hEN2k4L9BBlPfSVvMWb+GzeLzhn9s
	FhP7NS0unGpgsri8aw6bA6vH99Y+Fo8TM36zeGw+Xe3xeZNcAEsUl01Kak5mWWqRvl0CV8b2
	25+ZCqazV+y53crYwPiUtYuRk0NCwERi5rEpLBC2mMSFe+vZuhi5OIQEljBKLJ9zkxHCaWCS
	mNX1hhGkikVAVWLbufNg3WwCRhKvGlvAbBEBJYmvi+YygTQwC8xllPh24jBYQljAT2Lvvkdg
	zbwCVhIXV+8Fsjk4OAVsJc7tCwQJCwnYSHy/vAfqCieJV68nM0GUC0r8mHwPLM4soCWxeVsT
	K4QtL7F5zVvmCYwCs5CUzUJSNgtJ2QJG5lWMoqXFyQXFSem5hnrFibnFpXnpesn5uZsYIUFc
	tIPx2QarQ4wCHIxKPLwf7v4JEmJNLCuuzD3EKMHBrCTCO1Hrb5AQb0piZVVqUX58UWlOavEh
	RiYOTqkGRoOZP7eZWx2zeiDPeLbNzLf2bGDx7OVvdpyN1RKX2nHN22mJTO1tZv1n81j6Nxye
	Wlp/fvqyT8EdPoq2PDmdUz985BH48yjulmZvt1dZWU/lKZVVp4XyX+X3zDbea/Vd0cksWmPu
	jtlHgmftExG/0s80p9f4acPMypzJzeJxy3U15rKE39ZNUGIpzkg01GIuKk4EAP9BXFZAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 13 Feb 2014 22:35:16 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> From: Borislav Petkov <bp@suse.de>
> 
> We're more or less collecting EDAC patches already anyway so let's hold
> it down so that get_maintainer sees it too.
> 
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fee5e94b0d5e..5cded4b19918 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3082,6 +3082,8 @@ F:	fs/ecryptfs/
>  
>  EDAC-CORE
>  M:	Doug Thompson <dougthompson@xmission.com>
> +M:	Borislav Petkov <bp@alien8.de>
> +M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
>  L:	linux-edac@vger.kernel.org
>  W:	bluesmoke.sourceforge.net
>  S:	Supported


-- 

Cheers,
Mauro

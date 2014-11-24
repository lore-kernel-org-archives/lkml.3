Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaKXDGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 22:06:23 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53966 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKXDGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 22:06:21 -0500
From: "Dudley Du" <dudley.dulixin@gmail.com>
To: "'Jeremiah Mahler'" <jmmahler@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
References: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com> <20141121085611.GA21999@hudson.localdomain>
In-Reply-To: <20141121085611.GA21999@hudson.localdomain>
Subject: RE: [PATCH v11 00/19] input: cyapa: instruction of cyapa patches
Date: Mon, 24 Nov 2014 11:06:05 +0800
Message-ID: <000001d00793$9d756d90$d86048b0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHs8TC7NzDX2T8g722kgWRsHpjuWQI6s7qJnCNuqEA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

Thank you very much for your information.
I will look into this issue.
Could you send me the system log if possible when you encounter this issue.

Thanks
Dudley

> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: 2014?11?21? 16:56
> To: Dudley Du
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v11 00/19] input: cyapa: instruction of cyapa patches
> 
> Dudley,
> 
> On Wed, Nov 19, 2014 at 04:37:32PM +0800, Dudley Du wrote:
> > V11 patches have below main updates compared with v10 patches:
> > 1) Add add acpi device id supported for old gen3 and new gen5 trackpad
devices.
> > 2) Fix the unable to update firmware issue when cyapa_open is not called
> >    which means the irq for firwmare update process is not enabled. This fix
> []
> 
> I am having a problem with an older patch which is currently in
> linux-next (20141120) and which might be related to this new patch set.
> 
> On an Acer C720 if a suspend and resume is performed the touchpad will
> stop working.  If the cyapa driver is reloaded it will begin working
> again.
> 
> I performed a bisect and found that the following patch was the cause.
> 
>   From b1cfa7b4388285c0f0b486f152ab0cb18612c779 Mon Sep 17 00:00:00 2001
>   From: Dudley Du <dudley.dulixin@gmail.com>
>   Date: Sun, 9 Nov 2014 12:36:34 -0800
>   Subject: [PATCH] Input: cyapa - switch to using managed resources
> 
>   Use of managed resources simplifies error handling and device removal
>   code.
> 
>   Signed-off-by: Dudley Du <dudl@cypress.com>
>   [Dmitry: added open/close methods so cyapa_remove is no longer needed.]
>   Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> If I can provide any other information that would be of help let me know.
> I will try out your new patchset if I get a chance.
> 
> --
> - Jeremiah Mahler


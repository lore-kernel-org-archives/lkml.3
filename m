Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaBLQMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:12:10 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64629 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaBLQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:12:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140211203348.GA25883@kroah.com>
References: <1391935247-3797-1-git-send-email-navin.patidar@gmail.com>
	<1391935247-3797-3-git-send-email-navin.patidar@gmail.com>
	<20140211203348.GA25883@kroah.com>
Date: Wed, 12 Feb 2014 21:42:08 +0530
Message-ID: <CAPV97ycAs_=73DdRJgT1i9-4HHZpCFU2TkrhZx9LtuLOMekXfw@mail.gmail.com>
Subject: Re: [PATCH 3/3] staging: rtl8188eu: remove header file ethernet.h
From: navin patidar <navin.patidar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've submitted second version of this patch.

regards,
--navin-patidar

On Wed, Feb 12, 2014 at 2:03 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, Feb 09, 2014 at 02:10:46PM +0530, navin patidar wrote:
>> "ethernet.h" is included in three files but only "rtw_recv.c" using two macros
>> defined in "ethernet.h", so move used macros in "rtw_recv.c" and
>> remove "include/ethernet.h" header file and inclusion of this header file.
>>
>> Signed-off-by: navin patidar <navin.patidar@gmail.com>
>> ---
>>  drivers/staging/rtl8188eu/core/rtw_recv.c      |    4 ++-
>>  drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
>>  drivers/staging/rtl8188eu/include/ethernet.h   |   42 ------------------------
>>  drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    1 -
>>  4 files changed, 3 insertions(+), 45 deletions(-)
>>  delete mode 100644 drivers/staging/rtl8188eu/include/ethernet.h
>
> This patch fails to apply (2/3 had fuzz, but I fixed that up), can you
> redo this against linux-next and resend it?
>
> thanks,
>
> greg k-h

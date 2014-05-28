Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaE1PU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:20:59 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:52825 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaE1PU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:20:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140527190244.GA22680@kroah.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
	<1401204955-4093-3-git-send-email-navin.patidar@gmail.com>
	<20140527190244.GA22680@kroah.com>
Date: Wed, 28 May 2014 20:50:56 +0530
Message-ID: <CAPV97ycbem5BKRL6pCsxb2vLVWsF0-FPRXJk5PtBYJ-YUqr97w@mail.gmail.com>
Subject: Re: [PATCH 03/15] staging: rtl8188eu:Remove unused macro _init_queue()
From: navin patidar <navin.patidar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 12:32 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, May 27, 2014 at 09:05:43PM +0530, navin patidar wrote:
>> Signed-off-by: navin patidar <navin.patidar@gmail.com>
>> ---
>>  drivers/staging/rtl8712/osdep_service.h |    6 ------
>>  1 file changed, 6 deletions(-)
>
> This is the rtl8712 driver, not the rtl8188eu driver.
>
> And this patch causes a build error.
>
> Please ALWAYS test your patches before sending them out :(

Sorry
I made a silly mistake, i modified rtl8712 driver file unknowingly and
compiled rtl8188eu alone to test.
Next time i'll do a complete kernel build before sending patches out.

regards,
navin patidar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3EQKDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:03:33 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:46493 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3EQKDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130517004511.GA10492@kroah.com>
References: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
	<1366969040-28892-1-git-send-email-yhchen@faraday-tech.com>
	<20130517004511.GA10492@kroah.com>
Date: Fri, 17 May 2013 18:03:31 +0800
Message-ID: <CADB-GoKdtA9djmYXVwbeW_Yh_o5TQkS6PbXvRqqTCU-4Pk1EMw@mail.gmail.com>
Subject: Re: [PATCH v4] usb host: Faraday USB2.0 FUSBH200-HCD driver
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, sarah.a.sharp@linux.intel.com,
        Felipe Balbi <balbi@ti.com>, Julia.Lawall@lip6.fr,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 8:45 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Apr 26, 2013 at 09:37:20AM +0000, Yuan-Hsin Chen wrote:
>> FUSBH200-HCD is an USB2.0 hcd for Faraday FUSBH200.
>> FUSBH200 is an ehci-like controller with some differences.
>> First, register layout of FUSBH200 is incompatible with EHCI.
>> Furthermore, FUSBH200 is lack of siTDs which means iTDs
>> are used for both HS and FS ISO transfer.
>>
>> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>
> This patch breaks the build on my machine, so I can't accept it:
>   CC [M]  drivers/usb/host/fusbh200-hcd.o
> drivers/usb/host/fusbh200-hcd.c: In function ‘dbg_hcc_params’:
> drivers/usb/host/fusbh200-hcd.c:149:2: error: implicit declaration of function ‘HCC_HW_PREFETCH’ [-Werror=implicit-function-declaration]
> drivers/usb/host/fusbh200-hcd.c:149:2: error: implicit declaration of function ‘HCC_32FRAME_PERIODIC_LIST’ [-Werror=implicit-function-declaration]
> drivers/usb/host/fusbh200-hcd.c:149:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 6 has type ‘char *’ [-Wformat]
> drivers/usb/host/fusbh200-hcd.c: At top level:
> drivers/usb/host/fusbh200-hcd.c:906:12: warning: ‘debug_lpm_close’ defined but not used [-Wunused-function]
> cc1: some warnings being treated as errors
>
> Please be more careful.  Can you fix this up and resend it?

I am so sorry about the mistake. The fixed patch will be submitted soon.

>
> thanks,
>
> greg k-h

Yuan-Hsin Chen

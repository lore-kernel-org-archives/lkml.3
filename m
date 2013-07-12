Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab3GLBrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:47:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52425 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3GLBra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <51DEFDDF.7050803@infradead.org>
References: <20130711141745.04259271113c165310ec4768@canb.auug.org.au> <51DEFDDF.7050803@infradead.org>
From: Peter Chen <hzpeterchen@gmail.com>
Date: Fri, 12 Jul 2013 09:47:10 +0800
Message-ID: <CAL411-pROGd5y5UoShq=_QHUeHFdM8=kv5r0TRLa5o8T1h1bbQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 11 (usb/chipidea)
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 2:47 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 07/10/13 21:17, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130710:
>>
>
>
> on x86_64:
>
> # CONFIG_USB_GADGET is not set
>
> ERROR: "usb_gadget_map_request" [drivers/usb/chipidea/ci_hdrc.ko] undefined!
> ERROR: "usb_del_gadget_udc" [drivers/usb/chipidea/ci_hdrc.ko] undefined!
> ERROR: "usb_gadget_unmap_request" [drivers/usb/chipidea/ci_hdrc.ko] undefined!
> ERROR: "usb_add_gadget_udc" [drivers/usb/chipidea/ci_hdrc.ko] undefined!
>
>
>
> Full randconfig file is attached.
>
>

Should be fixed with below fix, the problem is the same with host.

http://marc.info/?l=linux-usb&m=137331577204167&w=2

--
BR,
Peter Chen

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbaDKNLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:11:33 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:44357 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbaDKNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:11:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140403154427.GB32027@khazad-dum.debian.net>
References: <531F0073.7060103@canonical.com> <20140403154427.GB32027@khazad-dum.debian.net>
From: Shuduo Sang <shuduo.sang@canonical.com>
Date: Fri, 11 Apr 2014 21:10:46 +0800
X-Google-Sender-Auth: PZCYpbPzr4cOubrc7xBYBHSdfZg
Message-ID: <CANqatMD2F-XCSZHoFaOsDA3o1JkVG2kLccYLr-=Z7b-cmC-6oA@mail.gmail.com>
Subject: Re: [ibm-acpi-devel] [PATCH] support thinkpad HKEY interface version 0x200
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: matthew.garrett@nebula.com, ibm-acpi@hmh.eng.br,
        linux-kernel@vger.kernel.org,
        ibm-acpi-devel <ibm-acpi-devel@lists.sourceforge.net>,
        Bruce Ma <bruce.ma@canonical.com>, paltform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

This patch is not in your recent for_linus branch. Why?

Thanks,
Shuduo

On Thu, Apr 3, 2014 at 11:44 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 11 Mar 2014, Shuduo Sang wrote:
>> Please kindly review following patch. It support new BIOS which shiped
>> with Thinkpad X1 Carbon 2nd generation. Without it, hotkey mask be
>> routed to wrong branch and some hot key will not work.
>
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>
> Can you guys get documentation on the new mode from Lenovo?
>
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
>
> ------------------------------------------------------------------------------
> _______________________________________________
> ibm-acpi-devel mailing list
> ibm-acpi-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ibm-acpi-devel

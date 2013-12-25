Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3LYHwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 02:52:07 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:35394 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3LYHwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 02:52:06 -0500
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
In-Reply-To: <52BA3A72.6080700@gmail.com>
References: <CACaajQv1OWxxcGORBq=LN-4JQzATf4YmWBQymoeyovfY-rUpmw@mail.gmail.com>
 <CAErSpo4uZ1N7uKyKMGHERtq-gvcpQ7oHTE7U9fGiAzfziMJ+Ew@mail.gmail.com> <52BA3A72.6080700@gmail.com>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Wed, 25 Dec 2013 11:51:49 +0400
X-Google-Sender-Auth: Ka8pBF9xvtXG97Vu2l4O_AMJWcc
Message-ID: <CACaajQv=UtqEfLU3vLPmixpvUf7u7D9NPZ-s6s_BMvPpSDVAig@mail.gmail.com>
Subject: Re: tg3 and sd card reader at acer aspire
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/25 Robert Hancock <hancockrwd@gmail.com>:
> So apparently this machine got broken when we changed the behavior for the
> ACPI ASPM-not-supported bit from forcing ASPM off for everything to leaving
> ASPM in whatever state the BIOS left it in. And apparently for some reason
> the device (devices?) doesn't work with ASPM enabled in Linux but does in
> Windows. It's possible that some other workaround is being applied by the
> Windows driver that allows it to work there.
>
> I'm not too sure what the next step to debug that would be, unless maybe
> someone has a contact at Broadcom. We could conceivably add a quirk to force
> ASPM off for this device regardless of what the BIOS says, though.


Thanks! I can contact with broadcom, but i don't known email address.
Last my attempt then i have problems with their wifi card not
successful =(.


-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru

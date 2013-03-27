Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3C0Vt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:49:29 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:45784 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3C0Vt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:49:27 -0400
MIME-Version: 1.0
In-Reply-To: <51532E51.6050201@xs4all.nl>
References: <51532E51.6050201@xs4all.nl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 27 Mar 2013 15:49:06 -0600
Message-ID: <CAErSpo5J9+2GF5afT3hUb6u8r1nwQi68mRja8Fq6BO-pb=zDhQ@mail.gmail.com>
Subject: Re: 3.8.4: ohci question
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-usb]

On Wed, Mar 27, 2013 at 11:37 AM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> Hello,
>
> When my dmesg gives me a growing number of lines like the one below,
> what is going on?
>
>  ohci_hcd 0000:00:12.0: urb ffff88023025c500 path 2 ep1in 6c160000 cc 6
> --> status -71
>
> Please let me know!
>
> Kind regards,
> Udo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

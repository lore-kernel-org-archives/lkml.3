Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaHaTJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:09:50 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:62594 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHaTJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <5401AA33.4010206@mev.co.uk>
References: <1409362832-1312-1-git-send-email-chase.southwood@gmail.com>
	<5401AA33.4010206@mev.co.uk>
Date: Sun, 31 Aug 2014 14:09:49 -0500
Message-ID: <CA+jnaaX9OsaAGO6MUjSLOoLE57E-egXd2VSmJ7irTOeCe6iuDw@mail.gmail.com>
Subject: Re: [PATCH] staging: comedi: usbdux: fix sparse endianness warnings
From: Chase Southwood <chase.southwood@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 5:40 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>
> That seems fine.  Perhaps the variable 'p' in usbdux_ao_insn_write() should
> also be of type '__le16 *'?
>

You're entirely correct.  I had seen this in the output from Sparse,
but for some reason at first glance I had convinced myself that the
fix would be more complicated than it is.  I'll get a patch out with a
Suggested-by: tag for you very soon.

Thanks,
Chase

> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
>
> --
> -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
> -=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

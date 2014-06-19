Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbaFSRfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:35:02 -0400
Received: from forward4h.mail.yandex.net ([84.201.186.22]:50060 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbaFSRfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:35:00 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2014 13:35:00 EDT
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Scott Alfter <scott@alfter.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GregKH <greg@kroah.com>
In-Reply-To: <31a597fc9f165ccc4998451b0ae91fc6.squirrel@webmail.alfter.us>
References: <31a597fc9f165ccc4998451b0ae91fc6.squirrel@webmail.alfter.us>
Subject: Re: revised driver: w1_ds2406
MIME-Version: 1.0
Message-Id: <6295551403198966@web5h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 19 Jun 2014 21:29:26 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott

I've added Greg to copy.

18.06.2014, 00:42, "Scott Alfter" <scott@alfter.us>:
> Some preliminary work at making use of this driver led me to implement
> CRC-16 checks on read and write to deal with the occasional glitchiness of
> the 1-Wire bus. šThe revised driver (attached) returns an I/O error if the
> CRC check fails. šWhen reading the chip's state, either you get a valid
> indication or you get an I/O error. šWhen changing its state, either the
> change is successful or an I/O error is returned.
>
> This patch supersedes the patch I had previously submitted.
>
> Signed-off-by: Scott Alfter <scott@alfter.us>

Greg, this patch looks good, please pull it into your tree.
If you already applied previous ds2406, let us know.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

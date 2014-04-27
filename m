Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaD0I6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 04:58:21 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61422 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaD0I6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 04:58:12 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.103.39]
In-Reply-To: <20140427051428.GA2671@katana>
References: <1398558586-28931-1-git-send-email-javier@dowhile0.org>
	<20140427051428.GA2671@katana>
Date: Sun, 27 Apr 2014 10:58:09 +0200
Message-ID: <CABxcv==8F2CghQKVDp==5Mx8-OBJnc+yZWEBqi7OFGij8OHaeg@mail.gmail.com>
Subject: Re: [Cocci] [PATCH 1/1] scripts/coccinelle: use BIT() macro if possible
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Coccinelle <cocci@systeme.lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

Thanks a lot for your feedback.

On Sun, Apr 27, 2014 at 7:14 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Sun, Apr 27, 2014 at 02:29:46AM +0200, Javier Martinez Canillas wrote:
>> Using the BIT() macro instead of manually shifting bits
>> makes the code less error prone and also more readable.
>
> Does it? It is a taste thing, yet I don't think it makes the code that
> much more readable that it is worth changing the whole tree.
>

I believe there is a reason for that macro but yes I agree with you
that is a matter of taste and the it shouldn't be enforced.

I'm doing a big refactoring for the GPIO subsystem and was told to use
coccinelle so this patch was part of my learning. I posted it because
I thought that it could be useful but I don't mind the patch to be
dropped if that is not the case.

Best regards,
Javier

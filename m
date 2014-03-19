Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064AbaCSNjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:39:52 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:54126 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964803AbaCSNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <1395230578.12633.21.camel@thorin>
References: <1395177092-3023-1-git-send-email-peter.senna@gmail.com>
	<1395230578.12633.21.camel@thorin>
Date: Wed, 19 Mar 2014 14:39:49 +0100
Message-ID: <CA+MoWDoSYu-aSp39vBe7DmayH2iqagHNYP9BC7LefajMXk+FnQ@mail.gmail.com>
Subject: Re: [PATCH] Coccicheck: Remove memcpy to struct assignment test
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, mmarek@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cocci@systeme.lip6.fr" <cocci@systeme.lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreea Bernat <bernat.ada@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 1:02 PM, Bernd Petrovitsch
<bernd@petrovitsch.priv.at> wrote:
> On Die, 2014-03-18 at 22:11 +0100, Peter Senna Tschudin wrote:
>> The Coccinelle script scripts/coccinelle/misc/memcpy-assign.cocci look
>> for opportunities to replace a call to memcpy by a struct assignment.
>> This patch removes memcpy-assign.cocci as it is not clear that this
>> convention has an impact on the generated code.
>
> Using struct assignment keeps the type check and is just for this reason
> always preferable over memcpy().
What about the assignment hiding that a potentially large memcpy is
happening instead of just a pointer assignment?

>
> Kind regards,
>         Bernd
> --
> Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
>                      LUGA : http://www.luga.at
>



-- 
Peter

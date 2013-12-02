Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab3LBUxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:53:13 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38710 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab3LBUxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:53:07 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4Hzon9Kcc0aDeGbbwUuvzx08n62UTYL11LsaY8FUUBRA@mail.gmail.com>
References: <20131202191248.517975703@linuxfoundation.org>
	<20131202191254.396768627@linuxfoundation.org>
	<CA+5PVA4Hzon9Kcc0aDeGbbwUuvzx08n62UTYL11LsaY8FUUBRA@mail.gmail.com>
Date: Mon, 2 Dec 2013 15:53:06 -0500
X-Google-Sender-Auth: 2s0eiyvtt7jIg839sxzm8Z8Dg6g
Message-ID: <CAOS58YMZaC87HMMr9huOZT2BHhg5JNNC+NedrdNmwhO=V_TgWQ@mail.gmail.com>
Subject: Re: [PATCH 3.12 056/212] ahci: add support for IBM Akebono platform device
From: Tejun Heo <tj@kernel.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alistair Popple <alistair@popple.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Dec 2, 2013 at 3:50 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> Signed-off-by: Alistair Popple <alistair@popple.id.au>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This one is a little funny.  There's really nothing wrong with the
> patch itself, nor adding it to 3.12.y, but it seems pretty pointless.
> The support for the Akebono board hasn't even landed in 3.13-rcX yet,
> and I really doubt it's going to show up in 3.12.y.  Seems kind of
> superfluous.

I generally automatically cc stable for patches which simply add
device IDs because they're low risk and distros / whoever is
maintaining older kernel wants to see them. Didn't know it wouldn't
work at all in earlier kernels. Please feel free to drop.

Thanks.

-- 
tejun

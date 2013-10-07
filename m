Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3JGRe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:34:59 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:36157 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3JGRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <20131007.125326.895480090584703586.davem@davemloft.net>
References: <1380880333-3546-1-git-send-email-ou.ghorbel@gmail.com>
	<20131007.125326.895480090584703586.davem@davemloft.net>
Date: Mon, 7 Oct 2013 18:34:53 +0100
Message-ID: <CABfLueGqa8wJv+hfcNQRmWM2tj6zMC5Ajts=-no7GJA1t09dnQ@mail.gmail.com>
Subject: Re: [PATCH] Fix the upper MTU limit in ipv6 GRE tunnel
From: Oussama Ghorbel <ou.ghorbel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I've resubmitted the patch with the proper Subject line.
The new mail subject is: [PATCH] ipv6: Fix the upper MTU limit in GRE tunnel


Thanks,
Oussama

On Mon, Oct 7, 2013 at 5:53 PM, David Miller <davem@davemloft.net> wrote:
> From: Oussama Ghorbel <ou.ghorbel@gmail.com>
> Date: Fri,  4 Oct 2013 10:52:13 +0100
>
>> Unlike ipv4, the struct member hlen holds the length of the GRE and ipv6
>> headers. This length is also counted in dev->hard_header_len.
>> Perhaps, it's more clean to modify the hlen to count only the GRE header
>> without ipv6 header as the variable name suggest, but the simple way to fix
>> this without regression risk is simply modify the calculation of the limit
>> in ip6gre_tunnel_change_mtu function.
>> Verified in kernel version v3.11.
>>
>> Signed-off-by: Oussama Ghorbel <ou.ghorbel@gmail.com>
>
> Please resubmit this with a proper Subject line.
>
> It should be "[PATCH] " then a legitimate subsystem prefix.
> In this case "ipv6: " would be appropriate.  And then
> the "ipv6" in your existing Subject text is redundant so
> can be removed.
>
> Thanks.

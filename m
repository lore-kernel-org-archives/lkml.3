Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3BUD4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 22:56:13 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41098 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3BUD4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 22:56:11 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com>
References: <20130220.170901.343210063003534302.davem@davemloft.net> <CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 20 Feb 2013 22:55:38 -0500
X-Google-Sender-Auth: gvF28q1jn7X2vWC3g724NlpnXRI
Message-ID: <CAP=VYLoMFXt7=MAdb-5uk6n8qiaG_99gw8haOjXDrYvzVSyvnQ@mail.gmail.com>
Subject: Re: [GIT] Networking
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 10:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Feb 20, 2013 at 2:09 PM, David Miller <davem@davemloft.net> wrote:
>>
>> 15) Orphan and delete a bunch of pre-historic networking drivers from
>>     Paul Gortmaker.
>
> Nooo.... You killed the 3c501 and 3c503 drivers! Snif.

Not true!  They were dead long ago, and here we were just providing
the service of a coroner, by removing the bodies vs. having them left to
decompose on the side of the street.

Paul.
--

>
> I wonder if they still worked..
>
>              Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

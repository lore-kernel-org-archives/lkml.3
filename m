Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3EMRna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:43:30 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:63764 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3EMRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:43:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=HOFqu8vB1=pvz79YwE8qAMDc4ZJACJHaSuxn4S92sFg@mail.gmail.com>
References: <1320756113.14409.385.camel@x61.thuisdomein> <20111108141647.GA3390@hash.lan>
 <1342124352.22584.21.camel@x61.thuisdomein> <20120712203837.GA3045@localhost>
 <4FFFBDD8.6020305@neratec.com> <20120713124134.GA5567@localhost>
 <1362999998.3137.60.camel@x61.thuisdomein> <1368457391.1350.67.camel@x61.thuisdomein>
 <CAJ-VmokciVPxzJ0LptdQyL9koa8Bw7ecJdentPH5q9+MQ4=GpA@mail.gmail.com>
 <5191173D.3070709@gmail.com> <CAJ-Vmo=HOFqu8vB1=pvz79YwE8qAMDc4ZJACJHaSuxn4S92sFg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 13 May 2013 10:43:06 -0700
X-Google-Sender-Auth: y-0rvk4iu6NrH-zjoNlnSuGEhb4
Message-ID: <CAB=NE6UR+3uadczBt+2n4g8j2e_A6OBJ-+ZJiO4y2g4Z0cFywg@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Remove AHB bus support.
To: Adrian Chadd <adrian@freebsd.org>
Cc: Jonathan Bither <jonbither@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>, Jiri Slaby <jirislaby@gmail.com>,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 10:09 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 13 May 2013 09:39, Jonathan Bither <jonbither@gmail.com> wrote:
>
>>> ... is anyone using this on openwrt?
>>>
>> I am.
>> I am also reworking AR2131X drivers and will submit a patch to linux-mips
>> shortly.
>
> Sweet. Someone say NACK then? :)

NACK, looking forward to the linux-mips patches, in the future however
we want to avoid these type of placeholder patches.

  Luis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab3BVQoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:44:13 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:53807 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab3BVQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:44:11 -0500
MIME-Version: 1.0
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F9C2DD07@G2W2436.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F9C2DD07@G2W2436.americas.hpqcorp.net>
Date: Fri, 22 Feb 2013 09:44:09 -0700
Message-ID: <CAKocOOOD-+2=0pb7Oin_tUdP5atzr3cRe1xY6j1zy3yFu1R2Pw@mail.gmail.com>
Subject: Re: [ stable-3.0] x86/apic: Work around boot failure on HP ProLiant
 DL980 G7 Server systems
From: Shuah Khan <shuahkhan@gmail.com>
To: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "trenn@suse.de" <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 4:04 AM, Zhang, Lin-Bao (Linux Kernel R&D)
<linbao.zhang@hp.com> wrote:
>
> Hi Greg,
>         I am very pleased to see this patch has been put into 3.8,3.7.9,and 3.4.4. thanks for your works.
> Do you have any plan to put it into stable-3.0.y version ? and other mainline ,such as 3.1.x,3.2.x,3.3.x ,etc. afterwards ?
> I see 3.0.66 is just released 8 hours ago, but without this patch. I guess maybe you are hard working on
> backporting this patch to 3.0.
>

Lin-Bao,

If you want this patch included in 3.0, you will have to back-port and
send it to stable mailing list marked for 3.0.

-- Shuah

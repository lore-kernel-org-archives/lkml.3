Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaLOA3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 19:29:01 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:35884 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaLOA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 19:28:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAJiQ=7APtRLarnAFFaDy1_KgnBN-wcK2=scOP5Ks0v5GH=AR3Q@mail.gmail.com>
References: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
 <CAJiQ=7C9qV2acVLWjacwsRmGMbyKUqCT5VbnO5TzeLLX73xMaQ@mail.gmail.com>
 <CAH2r5mteTRPVNTgVxNLqjdzok87HXxhC+xo+tnR3L0DKntSe6g@mail.gmail.com> <CAJiQ=7APtRLarnAFFaDy1_KgnBN-wcK2=scOP5Ks0v5GH=AR3Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 14 Dec 2014 18:28:31 -0600
Message-ID: <CAH2r5mucwo_FH4M=UUoLNDZNRFFcG9hd=Gxc7ma5jwkJQ2-qTg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [CIFS] Fix signed/unsigned pointer warning
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Sat, Dec 13, 2014 at 11:29 PM, Kevin Cernekee <cernekee@gmail.com> wrote:
> On Sat, Dec 13, 2014 at 9:20 PM, Steve French <smfrench@gmail.com> wrote:
>> Probably harmless patch - but I didn't notice the warning on x86
>> kernel build (building on Fedora 21, gcc 4.9.2)
>
> Did you test x86 32-bit or 64-bit?  In the generic do_div()

I built current mainline with 64 bit disabled. No warnings on this
before or after the patch.

> implementation, only the former case has an explicit type check.
>
> FWIW I'm on 32-bit bit MIPS.



-- 
Thanks,

Steve

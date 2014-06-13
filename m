Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaFMFsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:48:00 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33211 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaFMFr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXnXp45iRC1h=_pOYrvXPc=hrTYnnVgsUg+i9URVfJTow@mail.gmail.com>
References: <CAKx2Y1kBy-mrxm+1u88XVL2Z7gYKQe5U-EG2SBTzNCRAs_UVVw@mail.gmail.com>
	<CALCETrWMBAxz9yn4MMugjZGC_Dsi2p855+e99Qhr0Ab+OaGRXw@mail.gmail.com>
	<CALCETrV0zm_9a_jNxaw_=Ai1dozeqgFJYRh5xAmq_Qa7ErT-RQ@mail.gmail.com>
	<CAKx2Y1kTuK2cCn_uhVMgU5SeLsjXzHcFRmds7LP7-QG8BMqAdA@mail.gmail.com>
	<CALCETrXnXp45iRC1h=_pOYrvXPc=hrTYnnVgsUg+i9URVfJTow@mail.gmail.com>
Date: Thu, 12 Jun 2014 22:47:57 -0700
Message-ID: <CAKx2Y1mpUk_PurLG7w4ZdJ64Qw_dGgdM6yi2ecwwxzLC0CrhqQ@mail.gmail.com>
Subject: Re: Segmentation fault on all golang executables
From: Kui Zhang <kuizhang@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patches. The workaround works.

Stupid idea, maybe something in dmesg to help spark conversions, when
this workaround is hit?

Looks like golang people are close.


Thanks
Kuiz

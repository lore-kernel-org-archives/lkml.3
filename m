Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3IOI6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 04:58:53 -0400
Received: from trent.utfs.org ([94.185.90.103]:36961 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab3IOI6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 04:58:52 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130914111426.GB4663@cachalot>
References: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org> <87r4cybio2.fsf@xmission.com> <alpine.DEB.2.11.1309100124020.6509@trent.utfs.org> <20130914111426.GB4663@cachalot>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: proc hidepid=2 and SGID programs
From: Christian Kujau <lists@nerdbynature.de>
Date: Sun, 15 Sep 2013 01:58:42 -0700
To: Vasiliy Kulikov <segoon@openwall.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <eb1060ff-d56d-42b7-89f5-a459820edb82@email.android.com>
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov <segoon@openwall.com> wrote:
>> But still, I wonder if this is 
>> intended behaviour.
>
>Yes.
>
>If you think such side channel attacks are something you don't care,
>just turn hidepid off.  That's why it is an option.
>
>If you want to turn it off for some users, use gid=XXX.

Maybe my initial question got lost in the noise: I merely wondered why "pgrep sgid-program" returned nothing but "kill pics off stiff program" was possible. Sure, if that's intended behavior, so be it. I just don't understand the (technical) reasoning behind this.

Thanks,
Christian.



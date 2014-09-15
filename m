Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaIOF1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 01:27:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43603 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaIOF05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 01:26:57 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140915051850.GT7996@ZenIV.linux.org.uk>
References: <1410537212-3153-1-git-send-email-waydi1@gmail.com> <1410700510-15408-1-git-send-email-waydi1@gmail.com> <20140914181259.GQ7996@ZenIV.linux.org.uk> <CA+LGb9aaMpiotK7-NUv4hKcJHbuWQE=DC=p=90ZguWqn44qcTQ@mail.gmail.com> <20140915051850.GT7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] vfs: move getname() from callers to do_mount()
From: Seunghun Lee <waydi1@gmail.com>
Date: Mon, 15 Sep 2014 14:26:44 +0900
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Bruce Fields <bfields@fieldses.org>, ink@jurassic.park.msu.ru,
        jlayton@poochiereds.net, linux-fsdevel@vger.kernel.org,
        linux-alpha@vger.kernel.org, mattst88@gmail.com, rth@twiddle.net,
        linux-kernel@vger.kernel.org
Message-ID: <80cfae67-803f-4e94-b3d4-ac189e4c70f5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On September 15, 2014 2:18:50 PM GMT+09:00, Al Viro <viro@ZenIV.linux.org.uk> wrote:
>On Mon, Sep 15, 2014 at 01:39:19PM +0900, Seunghun Lee wrote:
>> 2014. 9. 15. 오전 3:13에 "Al Viro" <viro@zeniv.linux.org.uk> wrote:
>> > Applied with one modification: this getname/kern_path/putname is
>
>> Ok, I will resend it after modification.
>
>See above...  It's already in vfs.git#for-next.  The last commit of the
>branch at the moment.  The change was trivial - done it while applying
>the
>patch.

Oh sorry, I misunderstood your email.

Thanks.


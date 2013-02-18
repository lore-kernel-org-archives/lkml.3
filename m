Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3BRWOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 17:14:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50519 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab3BRWOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 17:14:43 -0500
Message-ID: <5122A7C1.3090305@oracle.com>
Date: Mon, 18 Feb 2013 16:14:25 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH V6 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com> <x49obg7omos.fsf@segfault.boston.devel.redhat.com> <510891ED.8090404@oracle.com> <x49d2wmqxui.fsf@segfault.boston.devel.redhat.com> <510973C8.1090209@oracle.com> <CA+icZUXG4xnGFC=R4nLJbtC2y5AD4Q_CvX1Q3SmGsT0W_7ZMUA@mail.gmail.com>
In-Reply-To: <CA+icZUXG4xnGFC=R4nLJbtC2y5AD4Q_CvX1Q3SmGsT0W_7ZMUA@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 03:42 PM, Sedat Dilek wrote:
> On Wed, Jan 30, 2013 at 8:26 PM, Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
>> By the way, I have updated the patchset in git. I removed the version
>> from the name of the branch and will keep this one updated:
>>
>> git://github.com/kleikamp/linux-shaggy.git aio_loop
> 
> What's the status of this patchset?

Based on some feedback from Hugh, I've been testing some changes to
iov_iter_copy_to_user().

> Will it go into Linux-Next? Through Al's VFS tree? Any chance to have
> it for-3.9?

I think it's about ready to push to linux-next.

Al, do you want this to go through the vfs tree, or straight from me to
linux-next?

Thanks,
Shaggy

> 
> - Sedat -

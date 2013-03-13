Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3CMK5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:57:38 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:43956 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3CMK5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:57:35 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CA+icZUXJn4=uU2M0pQ8B2=UAn2RS0bdY83uWKOS_SiDzZMb0FQ@mail.gmail.com>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUXJn4=uU2M0pQ8B2=UAn2RS0bdY83uWKOS_SiDzZMb0FQ@mail.gmail.com>
Date: Wed, 13 Mar 2013 11:57:33 +0100
Message-ID: <CAJfpegvCmwSzU3+02NxU15rovVFXPV_=y8eYaXq4xp997_kMTQ@mail.gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
From: Miklos Szeredi <miklos@szeredi.hu>
To: sedat.dilek@gmail.com
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 11:09 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Mar 12, 2013 at 4:41 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Al and Linus,
>>
>> Please consider overlayfs for inclusion into 3.10.
>>
>> It's included in Ubuntu and openSUSE, used by OpenWrt and various other
>> projects.  I regularly get emails asking when it will be included in mainline.
>>
>> Git tree is here:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v16
>>
>> Thanks,
>> Miklos
>>
>
> Hi Miklos,
>
> Is it possible to get a backport of OverlayFS-v16 for Linux-stable v3.8.y?
> Thanks in advance.

v15 is the backport, or rather, v16 is a forward port.  I changed
nothing else.  I'll do a .v17 with the comments addressed.

Thanks,
Miklos

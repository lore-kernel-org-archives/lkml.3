Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab3CMTzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:55:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47099 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:55:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: sedat.dilek@gmail.com
Cc: Felix Fietkau <nbd@openwrt.org>, Robin Holt <holt@sgi.com>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
	<CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
	<CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
	<CA+icZUV=XoN=uUn7npU9Djnkr5DEuA0D42=HV_1n6WN4v2rQMA@mail.gmail.com>
	<CA+icZUXXrarmm3hYSxt7T2_sw+pmZycdmop5z4QCJ6=vMny9EQ@mail.gmail.com>
	<CA+icZUXzYGRU7deUyzgNBEfSkZf+-w6VLOewd+7R=RmZ21mTUg@mail.gmail.com>
	<CAJfpegu3cHatcoWYyYeA-w0+mtQUgiAVkqUOjLGrq9oxk7CcrQ@mail.gmail.com>
	<CA+icZUWqd4OfjxBKeOjqaPiVXOvBk9kLu1u1X_hiG9sbz1Eneg@mail.gmail.com>
	<20130313181251.GA6023@sgi.com> <5140C77E.7030206@openwrt.org>
	<CA+icZUUPTryfL9S2vHopPTcRkhV=Qxd1w_fh0mWbPrUE7Lw=zQ@mail.gmail.com>
Date: Wed, 13 Mar 2013 12:54:51 -0700
In-Reply-To: <CA+icZUUPTryfL9S2vHopPTcRkhV=Qxd1w_fh0mWbPrUE7Lw=zQ@mail.gmail.com>
	(Sedat Dilek's message of "Wed, 13 Mar 2013 20:10:25 +0100")
Message-ID: <87k3pbhy7o.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+bCskr/zBsFzI5z/lEm6zAPF5E+W7p9oY=
X-SA-Exim-Connect-IP: 208.54.5.253
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;sedat.dilek@gmail.com
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Wed, Mar 13, 2013 at 7:37 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2013-03-13 7:12 PM, Robin Holt wrote:
>>> On Wed, Mar 13, 2013 at 05:51:33PM +0100, Sedat Dilek wrote:
>>>> On Wed, Mar 13, 2013 at 5:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> > On Wed, Mar 13, 2013 at 5:10 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> >
>>>> >> Anyway, with CONFIG_OVERLAYFS_FS=m I do not see any related messages
>>>> >> when the kernel-module is loaded.
>>>> >> So, is this intended?
>>>> >> SquashFS prints into the logs, so what is it doing differently?
>>>> >
>>>> > Some modules do, some don't.  It's not compulsory and not very useful.
>>>> >
>>>>
>>>> What about...
>>>>
>>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>>> index 482c26f..92b9ad5 100644
>>>> --- a/fs/overlayfs/super.c
>>>> +++ b/fs/overlayfs/super.c
>>>> @@ -675,11 +675,13 @@ MODULE_ALIAS_FS("overlayfs");
>>>>  static int __init ovl_init(void)
>>>>  {
>>>>         return register_filesystem(&ovl_fs_type);
>>>> +       printk(KERN_INFO "overlayfs: loaded\n");
>>>
>>> How about pr_debug().  That makes things quite for most of us but gives
>>> you info when looking for things like boot problems.
>> How is having a printk/pr_debug useful here at all? The fact that other
>> filesystems do this as well is not a good reason...
>> Also, putting it *after* the return statement doesn't make much sense ;)
>>
>
> Hehe, I just checked my new kernel... that does not work (nothing in the logs).
> But I think it's good to see if the filesystem is registered/loaded.

lsmod | grep overlayfs

Eric

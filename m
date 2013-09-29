Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab3I2HO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 03:14:28 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:54614 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3I2HO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 03:14:26 -0400
MIME-Version: 1.0
In-Reply-To: <5247B928.2070307@draigBrady.com>
References: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de>
	<1380117572.1974.81@driftwood>
	<1380119333.7453.4.camel@localhost.localdomain>
	<CAFLxGvzSSTbrw1HvoOaQBcPZxRbQmpiwjfbGCQtpLN7M9S93Fg@mail.gmail.com>
	<5247B928.2070307@draigBrady.com>
Date: Sun, 29 Sep 2013 09:14:25 +0200
Message-ID: <CAFLxGvzCp1JDL5yfuk7oRBGqi+re=NZWr-mg6nahs9NjFyDYwA@mail.gmail.com>
Subject: Re: Copy on write hard links?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Cc: Thomas Meyer <thomas@m3y3r.de>, Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 7:22 AM, Pádraig Brady <P@draigbrady.com> wrote:
> On 09/25/2013 03:37 PM, richard -rw- weinberger wrote:
>> On Wed, Sep 25, 2013 at 4:28 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>>> Am Mittwoch, den 25.09.2013, 08:59 -0500 schrieb Rob Landley:
>>>> On 09/24/2013 01:36:56 PM, Thomas Meyer wrote:
>>>>> Hi,
>>>>>
>>>>> Is there such a thing?
>>>>
>>>> In the kernel's vfs layer?
>>>
>>> Yes, that would be a nice feature!
>>
>> You mean reflinks?
>> Currently only OCFS2 and btrfs support them.
>> Both using a fs specific ioctl().
>> IIRC GNU cp uses the btrfs specific one if the --reflink parameter is used.
>
> coreutils is waiting for a reflink syscall to materialize
> rather than adding new per filesystem support
> http://lwn.net/Articles/335380/

Is this the correct link? It's a proposal for a reflink() syscall.
But corrently both OCFS2 and btrfs are using ioctl().

Digging into GNU coreutils shows that their cp's
clone_file() only supports the btrfs ioctl().
I don't know what the GNU folks big plan is, maybe you know more. :-)

-- 
Thanks,
//richard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3IYOhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:37:25 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:41589 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3IYOhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <1380119333.7453.4.camel@localhost.localdomain>
References: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de>
	<1380117572.1974.81@driftwood>
	<1380119333.7453.4.camel@localhost.localdomain>
Date: Wed, 25 Sep 2013 16:37:23 +0200
Message-ID: <CAFLxGvzSSTbrw1HvoOaQBcPZxRbQmpiwjfbGCQtpLN7M9S93Fg@mail.gmail.com>
Subject: Re: Copy on write hard links?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 4:28 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> Am Mittwoch, den 25.09.2013, 08:59 -0500 schrieb Rob Landley:
>> On 09/24/2013 01:36:56 PM, Thomas Meyer wrote:
>> > Hi,
>> >
>> > Is there such a thing?
>>
>> In the kernel's vfs layer?
>
> Yes, that would be a nice feature!

You mean reflinks?
Currently only OCFS2 and btrfs support them.
Both using a fs specific ioctl().
IIRC GNU cp uses the btrfs specific one if the --reflink parameter is used.

-- 
Thanks,
//richard

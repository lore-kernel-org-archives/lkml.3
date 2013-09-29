Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3I2FeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 01:34:14 -0400
Received: from mail1.vodafone.ie ([213.233.128.43]:40020 "EHLO
	mail1.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3I2FeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 01:34:09 -0400
X-Greylist: delayed 669 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Sep 2013 01:34:08 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAMS4R1JtTFzt/2dsb2JhbAANTYM/wUWBOIMZAQEBBDIBRhALDQsJFg8JAwIBAgFFBg0BBQIBAa9uknaPUQeEIgOeWY5E
Message-ID: <5247B928.2070307@draigBrady.com>
Date: Sun, 29 Sep 2013 06:22:48 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Thomas Meyer <thomas@m3y3r.de>, Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Copy on write hard links?
References: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de> <1380117572.1974.81@driftwood> <1380119333.7453.4.camel@localhost.localdomain> <CAFLxGvzSSTbrw1HvoOaQBcPZxRbQmpiwjfbGCQtpLN7M9S93Fg@mail.gmail.com>
In-Reply-To: <CAFLxGvzSSTbrw1HvoOaQBcPZxRbQmpiwjfbGCQtpLN7M9S93Fg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 03:37 PM, richard -rw- weinberger wrote:
> On Wed, Sep 25, 2013 at 4:28 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>> Am Mittwoch, den 25.09.2013, 08:59 -0500 schrieb Rob Landley:
>>> On 09/24/2013 01:36:56 PM, Thomas Meyer wrote:
>>>> Hi,
>>>>
>>>> Is there such a thing?
>>>
>>> In the kernel's vfs layer?
>>
>> Yes, that would be a nice feature!
> 
> You mean reflinks?
> Currently only OCFS2 and btrfs support them.
> Both using a fs specific ioctl().
> IIRC GNU cp uses the btrfs specific one if the --reflink parameter is used.

coreutils is waiting for a reflink syscall to materialize
rather than adding new per filesystem support
http://lwn.net/Articles/335380/

thanks,
Pádraig.

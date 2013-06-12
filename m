Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab3FLOPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:15:17 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53242 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3FLOPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:15:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130612140638.GA14776@roeck-us.net>
References: <20130611195312.352656079@linuxfoundation.org>
	<20130612140638.GA14776@roeck-us.net>
Date: Wed, 12 Jun 2013 10:15:13 -0400
Message-ID: <CA+5PVA5ti5w4uKOKQDUUST-aXTtHE_443xR=qGSfjfMtD0H5Bw@mail.gmail.com>
Subject: Re: [ 00/79] 3.9.6-stable review
From: Josh Boyer <jwboyer@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:06 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, Jun 11, 2013 at 01:02:26PM -0700, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.9.6 release.
>> There are 79 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu Jun 13 19:50:17 UTC 2013.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>       kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.6-rc1.gz
>> and the diffstat can be found below.
>>
> Hi Greg,
>
> Any chance to make those patches available as git repository somewhere, or
> at least as downloadable series of patches (eg as a tar file) which could
> be applied with git am ?

Is this what you're looking for?

git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

josh

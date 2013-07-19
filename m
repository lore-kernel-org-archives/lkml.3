Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814Ab3GSQ32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:29:28 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41532 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab3GSQ30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130719154648.GA23116@kroah.com>
References: <1374245148-24031-1-git-send-email-alexj@rosedu.org>
	<CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
	<CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com>
	<CAOJsxLFw4t-jwO4vDuMYfZA4uqH59h1c66xVPPFDO037OvGKSg@mail.gmail.com>
	<CAPhGq=Y30i0RWJTcomt5sRdKX6RDzdGHBo5L9D6coH8O0ej6kA@mail.gmail.com>
	<20130719154648.GA23116@kroah.com>
Date: Fri, 19 Jul 2013 19:29:25 +0300
Message-ID: <CAEnQRZBa5DNir15GK0mWsWTFu7yu1jyn=M2h76agbaXeszuy-w@mail.gmail.com>
Subject: Re: [PATCH] lustre:libcfs: remove redundant code.
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandru Juncu <alexj@rosedu.org>, Pekka Enberg <penberg@kernel.org>,
        "andreas.dilger" <andreas.dilger@intel.com>,
        "tao.peng" <tao.peng@emc.com>, driverdev <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>, pebolle@tiscali.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 6:46 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Jul 19, 2013 at 06:29:34PM +0300, Alexandru Juncu wrote:
>> On 19 July 2013 18:21, Pekka Enberg <penberg@kernel.org> wrote:
>> > On Fri, Jul 19, 2013 at 6:13 PM, Alexandru Juncu <alexj@rosedu.org> wrote:
>> >> I was thinking the same thing, but I hesitated because I didn't know
>> >> how used it was and I didn't want to break something.
>> >
>> > "git grep cfs_strdup" suggests that nobody uses it so you could just
>> > remove it completely...
>>
>> Did a grep on the tree and yes, it's not used. But It's in a staging
>> directory so maybe the rest of the code has not been pushed in yet.
>
> Doesn't matter, if there are no users, please just remove it.

Hi Greg,

There is already a similar patch for this https://lkml.org/lkml/2013/7/17/742,
already reviewed by Andreas Dilger.

thanks,
Daniel.

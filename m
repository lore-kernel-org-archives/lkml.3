Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaGHE3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:29:21 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52360 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaGHE3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <53BB6CF4.5010600@roeck-us.net>
References: <CAPDOMVjMpU4g5oPNHQYP2q6M-B7dxh1wPO3Nf4f=idCQcM8bfA@mail.gmail.com>
	<20140708033251.GA18777@kroah.com>
	<53BB6CF4.5010600@roeck-us.net>
Date: Tue, 8 Jul 2014 00:29:19 -0400
Message-ID: <CAPDOMVg+HGpvVYw1VAvaMFK7eXwKh-qZZfObzgzLCFtmQV3B2w@mail.gmail.com>
Subject: Fwd: shx3_defconfig Fails
From: Nick Krause <xerofoify@gmail.com>
To: linux@roeck-us.net, Greg KH <gregkh@linuxfoundation.org>
Cc: jslaby@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck  work on Tue, Jul 8, 2014 at 12:00 AM
Subject: Re: shx3_defconfig Fails

On 07/07/2014 08:32 PM, Greg KH wrote:
>
> On Mon, Jul 07, 2014 at 11:04:23PM -0400, Nick Krause wrote:
>>
>> Hey Greg and others,
>> The build, shx3_defconfig seems to be failing.
>
>
> In what kernel version?
>
> Has it ever worked?
>
> Why not ask the maintainer of that arch about it?  I doubt many people
> ever use defconfig files anymore...
>

Works in mainline for me. And, for the record, I use lots of defconfig files
(144 or so of them) for my build tests, so there is at least one user :-)

Cheers,
Guenter

Still fails in the the same way. I am using the latest git tree.
Cheers Nick

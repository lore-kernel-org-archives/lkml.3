Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaK0Pew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:34:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaK0Pev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:34:51 -0500
MIME-Version: 1.0
In-Reply-To: <201411271624.03066@pali>
References: <201411271506.20457@pali>
	<201411271543.23527@pali>
	<20141127151448.GA23064@kroah.com>
	<201411271624.03066@pali>
Date: Thu, 27 Nov 2014 23:34:47 +0800
Message-ID: <CACVXFVMMpY_99NrhLXeY-PMBFFACZxaE4hsq0+gff0YzHmeywg@mail.gmail.com>
Subject: Re: wl1251: NVS firmware data
From: Ming Lei <ming.lei@canonical.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Kalle Valo <kvalo@adurom.com>,
        Sebastian Reichel <sre@ring0.de>,
        David Gnedt <david.gnedt@davizone.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 11:24 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Thursday 27 November 2014 16:14:48 Greg Kroah-Hartman wrote:
>> On Thu, Nov 27, 2014 at 03:43:23PM +0100, Pali Rohár wrote:
>> > Which userspace helper programs for (automatic) firmware
>> > loading are used? Can be udev configured to use own program
>> > for loading firmware instead that udev integrated which
>> > looking for firmware only in /lib/firmware files?
>>
>> The code to load firmware from userspace has been removed from
>> udev, so that's not going to work at all, sorry.
>>
>> greg k-h
>
> Ok and how to load (dynamic) firmware files into kernel? What is
> preferred way if not udev (because it removed that support)?

As I said, it isn't difficult to write a helper with uevent monitor for
your case, and you can refer to mdev or android's implementation.

Thanks,
Ming Lei

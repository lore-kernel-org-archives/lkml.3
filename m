Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310Ab3E2Izm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:55:42 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60532 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965231Ab3E2Izh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <1369769542.8548.13.camel@jlt4.sipsolutions.net>
References: <CADDKRnBf4i8ZQ4EXC15Sa6z9CZ55w0vBDnXG26sjWgdO9zH45w@mail.gmail.com>
	<1369769542.8548.13.camel@jlt4.sipsolutions.net>
Date: Wed, 29 May 2013 10:55:37 +0200
Message-ID: <CADDKRnAWqg+-4hUpisTP7=ug8bpk5vWLEd1bZkPP=DWyiM5wrQ@mail.gmail.com>
Subject: Re: [v3.10-rc2] iwlwifi regression
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/28 Johannes Berg <johannes@sipsolutions.net>:
> On Sat, 2013-05-25 at 11:09 +0200, Jörg Otte wrote:
>> If iwlwifi/iwldvm are built into the kernel (no loadable modules)
>> following error is written to console and syslog since v3.10-rc:
>>
>> iwlwifi 0000:08:00.0: failed to load module iwldvm (error -38), is
>> dynamic loading enabled?
>
> So you just see the message, the driver actually works?
Yes, it works

>I'll just #ifdef the message.
Thanks!

Jörg

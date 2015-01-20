Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbbATHDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:03:21 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:43084 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbbATHDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:03:19 -0500
MIME-Version: 1.0
In-Reply-To: <20150113183441.GA24908@kroah.com>
References: <1421147642-28360-1-git-send-email-kiran.kumar@linaro.org>
	<20150113183441.GA24908@kroah.com>
Date: Tue, 20 Jan 2015 12:33:18 +0530
Message-ID: <CA+RfmHbK4FBZcwZ85HT-Zokv0P+XU7P5tXxH3tbyH-U_QjOh4w@mail.gmail.com>
Subject: Re: [RFC 1/2] misc: uidstat: Add uid stat driver to collect network statistics.
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Chan <mike@android.com>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, JP Abgrall <jpa@google.com>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2015 at 00:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jan 13, 2015 at 04:44:01PM +0530, Kiran Raparthy wrote:
>> From: Mike Chan <mike@android.com>
>>
>> misc: uidstat: Add uid stat driver to collect network statistics.
>>
>> To analyze application's network statistics, we need a mechanism to export
>> the UID based statistics to userspace so that userspace tools can use the
>> exported numbers and generate the report against the UID.
>>
>> This patch allows the user to explore the UID based network statistics
>> exported to /proc/uid_stat.
>
> This is a joke, right?  It's not April 1 yet people, why send this in
> January?
>
> confused,

Hi Greg,
It was part of clearing the backlog,didn't realize that this is obsolete.
Please ignore the patch-set.
Regards,
Kiran

>
> greg k-h

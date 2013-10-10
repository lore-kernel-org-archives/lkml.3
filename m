Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3JJIIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:08:22 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60312 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab3JJIIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:08:18 -0400
MIME-Version: 1.0
In-Reply-To: <20131009151330.GC14381@tuxdriver.com>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
	<1381128950-28125-7-git-send-email-gregkh@linuxfoundation.org>
	<20131009151330.GC14381@tuxdriver.com>
Date: Thu, 10 Oct 2013 10:08:18 +0200
Message-ID: <CACna6ryxcfZyObtBAd3a6R7rvgpfw2dtHYaGUwYUrcRL0wGRnQ@mail.gmail.com>
Subject: Re: [PATCH 06/11] bcma: convert bus code to use dev_groups
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/9 John W. Linville <linville@tuxdriver.com>:
> On Sun, Oct 06, 2013 at 11:55:45PM -0700, Greg Kroah-Hartman wrote:
>> The dev_attrs field of struct bus_type is going away soon, dev_groups
>> should be used instead.  This converts the bcma bus code to use the
>> correct field.
>>
>> Cc: Rafał Miłecki <zajec5@gmail.com>
>> Cc: <linux-wireless@vger.kernel.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>
>> Rafał, I can take this through my driver-core tree if you like, just let
>> me know what would be the easiest for you.
>
> Makes sense to me...

Oops, sorry, missed that. I'll just agree with John :)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965670AbaCUCi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:38:59 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39970 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892AbaCUCi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140321023505.GA17404@kroah.com>
References: <1438070.BphUZIHYWT@daeseok-laptop.cloud.net>
	<20140321023505.GA17404@kroah.com>
Date: Fri, 21 Mar 2014 11:38:57 +0900
Message-ID: <CAHb8M2AFsyau9mhxuBo5BiwAFKpkRVfu9Oad3VpSprc1s+zgVw@mail.gmail.com>
Subject: Re: [PATCH] staging: cxt1e1: replace kmalloc/kfree with OS_kmalloc/OS_kfree
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: shaun@xresource.ca, sachin.kamat@linaro.org, ebru.akagunduz@gmail.com,
        dulshani.gunawardhana89@gmail.com, speiro@ai2.upv.es,
        gulsah.1004@gmail.com, himangi774@gmail.com,
        peter.p.waskiewicz.jr@intel.com, fempsci@gmail.com,
        nandu.hgowda@gmail.com, sima.baymani@gmail.com,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tklauser@distanz.ch, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. It was already noticed by Joe Perches.
I will send it again.

Thanks.
Daeseok Youn.

2014-03-21 11:35 GMT+09:00, Greg KH <gregkh@linuxfoundation.org>:
> On Fri, Mar 21, 2014 at 10:41:39AM +0900, Daeseok Youn wrote:
>>
>> Replace kmalloc/kfree with OS_kmalloc/OS_kfree.
>
> I think you mean this the other way around, right?
>
>

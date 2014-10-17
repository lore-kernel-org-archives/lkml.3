Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaJQPyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:54:15 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39224 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaJQPyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:54:14 -0400
Message-ID: <54413B9B.9030702@ahsoftware.de>
Date: Fri, 17 Oct 2014 17:54:03 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Frans Klaver <fransklaver@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 00/27] Fix common bug in most nand drivers not showing
 a device in sysfs
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>	<543F678E.1030401@ahsoftware.de> <CAH6sp9O=36FTGg4FTCywsNzdJi4PjUmiiT6_EHr=i166+NA2ng@mail.gmail.com>
In-Reply-To: <CAH6sp9O=36FTGg4FTCywsNzdJi4PjUmiiT6_EHr=i166+NA2ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.10.2014 um 12:53 schrieb Frans Klaver:
> On Thu, Oct 16, 2014 at 8:37 AM, Alexander Holler <holler@ahsoftware.de> wrote:
>>
>> I wonder if anyone else will fix this in a maintainer-approved style which
>> doesn't use these evil leftovers from C666 called functions.
>
> I'll pick this up then.

Thanks.

>
> Still interested in following progress?

As you wish. It's such a simple patch, that I think every word about it
is almost a waste of time. I assume the result will be just 21
one-line-patches anyway, missing the chance to avoid similiar silly
patch series in the future by creating a common function (which even
reduces code size over all).

I've originally just did it because I've assumed any maintainer would
just wave it through not seeing a chance for big discussions.

So, if you like, just add my Signed-off-by too, there isn't really much
one could do wrong. ;)

Thanks again,

Alexander Holler

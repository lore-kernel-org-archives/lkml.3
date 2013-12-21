Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3LUQ0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 11:26:47 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:45055 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3LUQ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 11:26:45 -0500
MIME-Version: 1.0
In-Reply-To: <52B5C034.50800@linux.com>
References: <1387641453-13803-1-git-send-email-standby24x7@gmail.com>
	<52B5C034.50800@linux.com>
Date: Sun, 22 Dec 2013 01:26:44 +0900
Message-ID: <CALLJCT2r1Qs1aHt2gVAobOx209y_asqcQu83J0rQTVxMax+oMA@mail.gmail.com>
Subject: Re: [PATCH] [trivial] doc: cgroups: Fix typo in doc/cgroups
From: Masanari Iida <standby24x7@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 1:22 AM, Levente Kurusa <levex@linux.com> wrote:
> Hi,
>
> spotted one more typo.
>
> On 12/21/2013 04:57 PM, Masanari Iida wrote:
>> diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
>> index c4d99ed..52e1da1 100644
>> --- a/Documentation/cgroups/resource_counter.txt
>> +++ b/Documentation/cgroups/resource_counter.txt
>> @@ -97,8 +97,8 @@ to work with it.
>>               (struct res_counter *rc, struct res_counter *top,
>>                unsinged long val)
>                  ^^^^^^^^^^ should be unsigned.
>
> --
> Regards,
> Levente Kurusa

That typo was reported some times ago.
https://lkml.org/lkml/2013/12/5/468
So I didn't fix it by myself.

Thanks
Masanari

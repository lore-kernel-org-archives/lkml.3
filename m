Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbbAZIbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 03:31:10 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:32823 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbbAZIbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 03:31:07 -0500
Message-ID: <54C5FB3F.6000803@gmail.com>
Date: Mon, 26 Jan 2015 09:30:55 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Zhang Rui <rui.zhang@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] int to bool conversion
References: <20150122084941.GA14651@sloth> <1659960.ohcxabvmYi@vostro.rjw.lan>
In-Reply-To: <1659960.ohcxabvmYi@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in answering ....

On 22/01/2015 17:18, Rafael J. Wysocki wrote:
> On Thursday, January 22, 2015 09:49:41 AM Quentin Lambert wrote:
>> These patches convert local variables from int to bool when relevant.
> And what exactly is the need for that?  Does that fix any functional problems?
>
>
It doesn't fix any functional problem. The point of this patch
is to increase the code readability by lifting some of the ambiguities
that appear when using an integer variable as boolean.

My understanding is that by explicitly using a boolean declaration
when it is relevant it clearly informs the reader that the variable
is going to represent a binary state. Moreover, using the keywords
true and false help indicate that the variable will not be involved
in any computation other than boolean arithmetic.

That being said, I am new to kernel contribution and I feel that
a more compelling case may be made here:
http://lkml.iu.edu/hypermail/linux/kernel/0607.2/0791.html

BR,
Quentin

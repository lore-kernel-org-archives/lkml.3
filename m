Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaIYSYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:24:06 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34611 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaIYSYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:24:03 -0400
MIME-Version: 1.0
In-Reply-To: <54245C94.2020708@canonical.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-3-git-send-email-yinghai@kernel.org>
	<CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
	<CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
	<CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
	<CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
	<52A8BAC5.70006@canonical.com>
	<CAE9FiQV8mfF6SMTbZN5H+DmyuM0663wQyoKYJDa7MiBR4i7XQg@mail.gmail.com>
	<52D01D82.5070202@canonical.com>
	<CAE9FiQUD0XvPJNFNMoqX6J67TKuGcj+pSbj+iPUf=fvC-4UXOQ@mail.gmail.com>
	<54189BCE.2010206@canonical.com>
	<CAE9FiQX1pfciTcuF3_eggQLCn=LvTSLTT0UZxTb+z_RaLHwgJQ@mail.gmail.com>
	<CAE9FiQWphiORhaVNNVGZXY6eYxLH2QYNbHcLdjzrBD98tMKz0Q@mail.gmail.com>
	<54245C94.2020708@canonical.com>
Date: Thu, 25 Sep 2014 11:24:01 -0700
X-Google-Sender-Auth: SBcCg9548clEgw7VKRE4MU94rzw
Message-ID: <CAE9FiQX-ZDTOa6fKvHry8XCqPKSLZt8QKYm97cZXJsRNLB9yRg@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
From: Yinghai Lu <yinghai@kernel.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:19 AM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> On 09/17/2014 03:46 AM, Yinghai Lu wrote:
>> On Tue, Sep 16, 2014 at 3:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Tue, Sep 16, 2014 at 1:21 PM, Joseph Salisbury
>>> <joseph.salisbury@canonical.com> wrote:
>>>> A new bug[0] was opened due to enabling PCI_REALLOC_ENABLE_AUTO, which
>>>> is similar to the original bug[1] we discussed.
>>>>
>>>> Just wondering if there have been any additional ideas on realloc since
>>>> this was last discussed?
>>>>
>>>> [0] http://pad.lv/1363313
>>> So the resource realloc do work as expected. but LSI firmware has some
>>> problem again?
>>>
>>> We may need to add command after the reset the bridge resource.
>> Can you try attached patch?
>>
>> Thanks
>>
>> Yinghai
> Sorry, this message was marked as SPAM for some reason.  Do you still
> want this patch tested?

Yes, Please.

We need special handling for LSI devices.

Thanks

Yinghai

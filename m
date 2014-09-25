Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaIYQFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:05:10 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34782 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaIYQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <54243978.3030501@canonical.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
 <1386546869-31900-3-git-send-email-yinghai@kernel.org> <CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
 <CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
 <CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
 <CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
 <52A8BAC5.70006@canonical.com> <CAE9FiQV8mfF6SMTbZN5H+DmyuM0663wQyoKYJDa7MiBR4i7XQg@mail.gmail.com>
 <52D01D82.5070202@canonical.com> <CAE9FiQUD0XvPJNFNMoqX6J67TKuGcj+pSbj+iPUf=fvC-4UXOQ@mail.gmail.com>
 <54189BCE.2010206@canonical.com> <CAE9FiQX1pfciTcuF3_eggQLCn=LvTSLTT0UZxTb+z_RaLHwgJQ@mail.gmail.com>
 <54243978.3030501@canonical.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Sep 2014 10:04:44 -0600
Message-ID: <CAErSpo7unezE4hRYDUsHbmAV+dxgaMFqBOU=svpUEFKieG=omA@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 9:49 AM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> On 09/16/2014 06:27 PM, Yinghai Lu wrote:
>> On Tue, Sep 16, 2014 at 1:21 PM, Joseph Salisbury
>> <joseph.salisbury@canonical.com> wrote:
>>> A new bug[0] was opened due to enabling PCI_REALLOC_ENABLE_AUTO, which
>>> is similar to the original bug[1] we discussed.
>>>
>>> Just wondering if there have been any additional ideas on realloc since
>>> this was last discussed?
>>>
>>> [0] http://pad.lv/1363313
>>> [1] http://pad.lv/1245938

As a side-note, this looks like a regression and I should have given
it more attention, but I don't track all the vendor bug databases.  If
you open a kernel.bug bugzilla and mark it as a regression, I *do*
track that regularly.  For regressions, it's helpful if you can attach
dmesg logs from working and non-working kernels that are as close
together as possible.  It'd be ideal if those were upstream kernels,
but I doubt you apply any patches that would be relevant, so I think
logs from Ubuntu kernels would be enough.

Bjorn

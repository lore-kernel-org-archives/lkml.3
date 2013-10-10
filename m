Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3JJPqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:46:24 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:35249 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab3JJPqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:46:21 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20131010132625.GA3942@zurbaran>
References: <1348663684-1377-1-git-send-email-ldewangan@nvidia.com>
	<CAOesGMjQ=RfKVxpBAfFAanb5bXuwgNtL+fwDaJGNVXQgyTneKw@mail.gmail.com>
	<20131010132625.GA3942@zurbaran>
Date: Thu, 10 Oct 2013 08:46:20 -0700
Message-ID: <CAOesGMhhj6A6XLtUa+eAqAnSzM=J_PeAy5cEFYHtxk0VFs-icQ@mail.gmail.com>
Subject: Re: [REPOST/PATCH] mfd: tps65910: remove warning during dt node parsing
From: Olof Johansson <olof@lixom.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 10, 2013 at 6:26 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Olof,
>
> On Wed, Oct 09, 2013 at 05:51:14PM -0700, Olof Johansson wrote:
>> Hi,
>>
>> On Wed, Sep 26, 2012 at 5:48 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>> > Driver throw the warning message if dt node does not
>> > have the info for VMBCH-Threshold and VMBCH2-Threshold.
>> > These properties are optional property and hence it
>> > is not mandatory to have these on DT node and in this case
>> > it should not throw the warning message.
>> > It creates noise from driver as follows:
>> > [    0.384605] tps65910 4-002d: VMBCH-Threshold not specified
>> > [    0.384616] tps65910 4-002d: VMBCH2-Threshold not specified
>> >
>> > Removing the warning message from driver.
>> >
>> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> > ---
>> > It seems orginal patch has been lost. Reposting it.
>>
>> I still see this with 3.12-rc. Sam?
> I can take it through mfd-next, but do you really think it's material
> for mfd-fixes ?

Oh, 3.13 is definitely fine, it'd just be good to see it not fall
between the cracks. It's a harmless warning.


-Olof

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3KVCMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:12:43 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47780 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KVCMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:12:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131121211822.GA10691@einon.net>
References: <cover.1384933520.git.gamerh2o@gmail.com>
	<20131121211822.GA10691@einon.net>
Date: Fri, 22 Nov 2013 10:12:41 +0800
Message-ID: <CAAb+SYbgNBhyp7-+OEuPtQfSDg=cMNF_zpqx15K5FygOmHWQ1w@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] staging: et131x: patches for et131x driver
From: ZHAO Gang <gamerh2o@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 5:18 AM, Mark Einon <mark.einon@gmail.com> wrote:
> On Wed, Nov 20, 2013 at 03:53:50PM +0800, ZHAO Gang wrote:
>> This patch set should apply to current staging-next tree
>>
>> ZHAO Gang (5):
>>   staging: et131x: clean up code
>>   staging: et131x: drop packet when error occurs in et131x_tx
>>   staging: et131x: stop read when hit max delay in et131x_phy_mii_read
>>   staging: et131x: remove spinlock adapter->lock
>>   staging: et131x: update TODO list
>>
>>  drivers/staging/et131x/README   |   5 -
>>  drivers/staging/et131x/et131x.c | 301 +++++++++++++++++-----------------------
>>  2 files changed, 127 insertions(+), 179 deletions(-)
>>
>> --
>
> Hi Zhao,
>
> Thanks for the patches. A few pointers for the future:
>
> - Use scripts/get_maintainer.pl to discover to which mailing lists /
> maintainers patches should be sent. I've cc'd devel@driverdev.osuosl.org
> which was missing from your original submission.

I will add it to cc list next time.

>
> - Please don't roll up patches you've previously sent into newer
> patchsets, even if they haven't been applied by the tree maintainer
> yet. This just means that the same lines of code get reviewed twice,
> wasting the reviewer's time.

Greg also told me this problem, I will not do this any more.

>
> Cheers,
>
> Mark

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaJUJKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:10:52 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59430 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbaJUJKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:10:49 -0400
MIME-Version: 1.0
In-Reply-To: <3078007.YbCSC1R6J1@wuerfel>
References: <CAJe_Zhf73TXxAjBq_cCJB_oBC1Ff_ErN7TP4HsO-_BzhiPZkGQ@mail.gmail.com>
	<CAJe_ZhcXTp6phuS=8nYuXTD3yUHsu7QKap85iVgfcZsrmOK59g@mail.gmail.com>
	<3078007.YbCSC1R6J1@wuerfel>
Date: Tue, 21 Oct 2014 14:40:48 +0530
Message-ID: <CAJe_ZhdR_aTU1BCLsHYCxnaWs8AE+BEf4P18B_Mi==8kVO9qCQ@mail.gmail.com>
Subject: Re: [GIT PULL] New Mailbox framework for 3.18
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: torvalds@linux-foundation.org,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Matt Porter <mporter@linaro.org>, LeyFoon Tan <lftan.linux@gmail.com>,
        "Anna, Suman" <s-anna@ti.com>, Bjorn Andersson <bjorn@kryo.se>,
        Mark Brown <broonie@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Andy Green <andy.green@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Alexandre Torgue <alexandre.torgue@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 13:13, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 20 October 2014 15:23:38 Jassi Brar wrote:
>> On 8 October 2014 11:09, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>> > Hi Linus,
>> >
>> > A framework for Mailbox controllers and clients have been cooking for
>> > more than a year now. Everybody in the CC list had been copied on
>> > patchset revisions and most of them have made sounds of approval,
>> > though just one concrete Reviewed-by. The patchset has also been in
>> > linux-next for a couple of weeks now and no conflict has been
>> > reported. The framework has the backing of at least 5 platforms,
>> > though I can't say if/when they upstream their drivers (some
>> > businesses have 'changed').
>> >
>> Hi Linus,
>>   While I was speculating on the reasons why you were not merging the
>> patchset - not enough Acked-Bys, you want it via asoc, my git server
>> down (I am not aware) or you just forgot in the unlikely case - I
>> missed the window.
>>  There are couple of platforms waiting for the api to get upstream and
>> now I have the devs on my back. Assuming I messed up the pull request
>> somehow, may I know how?
>
> Jassi,
>
> I assume a contributing factor here was that you rebased the tree
> just before submission, which is always a bad sign.
>
> There is a small chance that Linus will still pull this for v3.18, as he
> said that he'd take a few things that have been submitted in time. If
> not, please rebase once more on top of v3.18-rc1 and send a pull request
> to arm@kernel.org so we can put it into arm-soc for 3.19.
>
OK, I will. And thanks for pointing out the issue with rebasing.

Thanks
Jassi

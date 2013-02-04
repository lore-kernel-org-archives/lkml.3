Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3BDIbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:31:15 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:51573 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3BDIbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:31:14 -0500
MIME-Version: 1.0
In-Reply-To: <17352980.268481359965953092.JavaMail.weblogic@epml13>
References: <17352980.268481359965953092.JavaMail.weblogic@epml13>
Date: Mon, 4 Feb 2013 14:01:13 +0530
Message-ID: <CAM4voakFpXwG7ukO5p4=NKDQZc--rcLDPU8jGag_gB=4ZdvRAA@mail.gmail.com>
Subject: Re: Re: [PATCH v4 4/4] PM: Devfreq: Add Exynos5-bus devfreq driver
 for Exynos5250
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: myungjoo.ham@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        =?UTF-8?B?7LWc7KKF7ZmY?= <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 4, 2013 at 1:49 PM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> Hi,
>>
>> > Sorry for being late.
>> >
>> > One concern is that I cannot apply Patch 1/4 directly as the .dts file isn't
>> > available to me.
>> > Do you intend to apply that patch to another tree and apply the other three
>> > to devfreq tree?
>> I have been merging the devfreq tree into Kgene's tree for my testing. I am not
>> sure how this should get in, any suggestions ?
>
> I'd suggest to send Patch 1/4 to Kgene and get it applied first if that patch is preliminary to the other patchset. If it is not, we can go seperated and independently.
Thanks for the suggestion. Kgene is a recipient on patches 1 and 2. I
am hoping he'll pick it up soon. However, the devfreq patches are not
dependent on them and can be applied independently.
>
>> >
>> > Another is the location of exynos_ppmu.h.
>> > Who is going to refer exynos_ppmu.h?
>> > If Exynos devfreq drivers are the only files to refer, wouldn't it be better
>> > located at drivers/devfreq/exynos/ ?
>> >
>> > Or do you intend to let someone else (drivers located not in
>> > drivers/devfreq) access exynos-ppmu?
>> > (If so, who's going to be? and that means we are going to have
>> > include/linux/devfreq/, I don't think it'd be appropriate to populate
>> > include/linux with device driver specific headers)
>> In an earlier comment on this patch Olof suggested I place it in
>> include/linux/. It is going to be
>> used only by Exynos and I will move it into drivers/devfreq/exynos as
>> per your suggestion.
>
> If it is to be used by Exynos non-devfreq drivers (e.g., Exynos ADC driver in drivers/iio/...), it should be stting on include/linux/devfreq/. If it is to be used by Exynos devfreq drivers only, it'd be better located at drivers/devfreq/exynos/. It appears to be still compatible with Olof's suggestion:
>
> (quoting Olof) "Local defines that are used in just one C file can either go in that file, or in a header file that sits next to it instead of in the shared directory."
Understood, updated patch 4/4 in a bit.
>
>

 Abhilash

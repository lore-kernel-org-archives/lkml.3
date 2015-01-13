Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbbAMQTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:19:36 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:53213 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbbAMQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:19:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAK9yfHzJL2ZKLyg7NtJisFUorTy0oVoOUwGtnWbQYGsysgG-UA@mail.gmail.com>
References: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
	<CAJ0PZbS8FxRA_sPTOnWbZcNfUMp=k5Jf_tZHLg1fh6gsAGJ=Gw@mail.gmail.com>
	<CAK9yfHzUAnBMB2Bp+eKzR3NH1iRguJn4K45gss5psWzG4Lc7tw@mail.gmail.com>
	<CAM4voak0QaseYoRM+rsx2Fa8qs1z=w9iVep1smxx73_SUhmkJQ@mail.gmail.com>
	<CAK9yfHzJL2ZKLyg7NtJisFUorTy0oVoOUwGtnWbQYGsysgG-UA@mail.gmail.com>
Date: Tue, 13 Jan 2015 08:19:31 -0800
Message-ID: <CAGa+x878dJrxc_QPg2_n3OiuswMbeVs=mXR=j71+EF=vDqs4ng@mail.gmail.com>
Subject: Re: [RFC v2 0/4] Add basic support for ASV
From: Kevin Hilman <khilman@linaro.org>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Sachin Kamat <spk.linux@gmail.com>
Cc: Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Bresticker <abrestic@google.com>,
        Doug Anderson <dianders@google.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 10:00 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Abhilash,
>
> On 3 December 2013 20:16, Abhilash Kesavan <kesavan.abhilash@gmail.com> wrote:
>> Hi Yadwinder and Sachin,
>
>> CC'ing Doug and Andrew who have also worked on ASV.
>>
>> I tested these patches on a 5250 Chromebook after modifying the
>> cpufreq code and a few other changes for booting the board. The driver
>> is retrieving the ASV fused group correctly. The behavior on an
>> unfused SMDK5250 is also fine.
>> I have a few minor comments on the patches.
>>
>
> Thank you for testing and reviewing the patchset.
> Will incorporate your comments in the next version.

Has there been an updated version of this series posted?    I can't
seem to find one.

Kevin

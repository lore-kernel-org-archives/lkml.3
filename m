Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3AKNeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:34:18 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:38472 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3AKNeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:34:14 -0500
MIME-Version: 1.0
In-Reply-To: <50ED62B3.50000@st.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
	<1355836212-17956-2-git-send-email-loic.pallardy-ext@stericsson.com>
	<20121218165909.GF4989@atomide.com>
	<50D423C2.3090009@st.com>
	<B5906170F1614E41A8A28DE3B8D121433EC9CF77@DBDE01.ent.ti.com>
	<50D43FA4.8090000@st.com>
	<B5906170F1614E41A8A28DE3B8D121433ECDD8C1@DBDE01.ent.ti.com>
	<50ED62B3.50000@st.com>
Date: Fri, 11 Jan 2013 07:34:12 -0600
Message-ID: <CAJ6Av5M==RCCc-ngKMebPgqUwVT5Gr7E=NNk4Rr2OQK5TzfORQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] mailbox: OMAP: introduce mailbox framework
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Loic PALLARDY <loic.pallardy@st.com>
Cc: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>, Tony Lindgren <tony@atomide.com>,
        Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Gutierrez, Juan" <jgutierrez@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>,
        "Anna, Suman" <s-anna@ti.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 6:29 AM, Loic PALLARDY <loic.pallardy@st.com> wrote:
> Hi Vaibhav,
>
> On 01/09/2013 01:11 PM, Bedia, Vaibhav wrote:
>> Hi Loic,
>>
>> On Fri, Dec 21, 2012 at 16:23:24, Loic PALLARDY wrote:
>>>
>>>
>>> On 12/21/2012 11:49 AM, Bedia, Vaibhav wrote:
>>>> On Fri, Dec 21, 2012 at 14:24:26, Loic PALLARDY wrote:
>>>>>
>>>> I have a few patches which are dependent on this patch series.
>>>> Could you please keep me in cc for the future versions.
>>>>
>>> Sure, I'll.
>>>
>>
>> When do you plan to post an updated version of these patches?
> I'm synchronizing with Omar to include TI RPMsg and tidspbridge patches
> in next update.
> So I plan update for end of the week, beginning of next week.

Here are my patches, I didn't post them to the list since they are
meant to be squashed, I also prepared a squashed version of the
original set, in case it is easier to take that one, all rebased into
3.8-rc1. Branches: mailbox-3.8-rc1-separate-changes and
mailbox-3.8-rc1, respectively.

>From tree: https://github.com/omarrmz/upstream-wip

Cheers,

Omar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628Ab3LIGlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:41:35 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51100 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549Ab3LIGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:41:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAFi4uRsuPUjxAOWuMkeBYd1fmT_CQdVdeffVRN1yxPVRcWuALA@mail.gmail.com>
References: <CAFi4uRvcUPvKvaeO5gZnjhMCFS+08MhEixJw-iN0AWbeBfiHvQ@mail.gmail.com>
	<CAErSpo7rbf7dwSZ12uoVXaf6HoRNDn0Pxxy-Vo_6F9kk+p07Qg@mail.gmail.com>
	<CABawtvNbkeXdQiBYD9Q+oRijw6VnT=FHdiFkjvFfh8Uw8KvO_A@mail.gmail.com>
	<CAFi4uRsuPUjxAOWuMkeBYd1fmT_CQdVdeffVRN1yxPVRcWuALA@mail.gmail.com>
Date: Mon, 9 Dec 2013 14:41:32 +0800
Message-ID: <CABawtvNEE5LzywovC3X4GSAOkRpTkwoy-LWJ_UguOaK1br9F1A@mail.gmail.com>
Subject: Re: NETDEV WATCHDOG: eth0 (e1000e): transmit queue 0 timed out
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Nick Pegg <nick@nickpegg.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Jin Feng <joe.jin@oracle.com>, konrad.wilk@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,
    You could try 7.3.21-k8-NAPI in tree or the out-of-tree version as
Bjorn mentioned.
To read and debug an old version driver is not a interesting thing for
somebody to do.

Thanks,
Ethan

On Tue, Dec 3, 2013 at 9:33 PM, Nick Pegg <nick@nickpegg.com> wrote:
> On Mon, Dec 2, 2013 at 10:51 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
>> Bjorn,
>>    Seems not the same bug as  http://sourceforge.net/p/e1000/bugs/367/
>> ,  Nick is not running his kernel on bare metal, per the error log,
>> he runs his kernel as HVM DomU guest or Dom0 on XEN ?  so just a check
>> of NULL will not fix that.
>>
>
> Sorry, I neglected to say in my original email that the kernel is
> running as a Xen Dom0. Per Todd's request, I've opened a bug report on
> sourceforge and will follow up with this issue there:
> https://sourceforge.net/p/e1000/bugs/385/
>
> Thanks,
> Nick

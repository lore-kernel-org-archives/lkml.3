Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3CFWyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:54:55 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:40620 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3CFWyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:54:53 -0500
MIME-Version: 1.0
In-Reply-To: <5137C7BE.9090506@linux.intel.com>
References: <20130306100743.GA407@polaris.bitmath.org>
	<CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
	<20130306193612.GA513@polaris.bitmath.org>
	<51379A4F.4020200@linux.intel.com>
	<20130306195457.GA449@polaris.bitmath.org>
	<CAE9FiQWK0ZnG9o8WgU-pcTPpir=PUyULQqk-TRVC+sh6UpU8VA@mail.gmail.com>
	<20130306204500.GA335@polaris.bitmath.org>
	<5137AE06.8060200@linux.intel.com>
	<CAE9FiQW6SegoYjoveCVGWS3h-0UOHp5_wuAwnVh14oKLyYQFKA@mail.gmail.com>
	<5137B9DB.6000605@linux.intel.com>
	<20130306220412.GA1064@polaris.bitmath.org>
	<5137C2C7.3020302@linux.intel.com>
	<CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com>
	<5137C7BE.9090506@linux.intel.com>
Date: Wed, 6 Mar 2013 14:54:53 -0800
X-Google-Sender-Auth: kcf8_bqQrHIlZ53l0LGAnj8NPjk
Message-ID: <CAE9FiQUECh=RNpuxAGRef+StDxVncs6iRrvX13CrCThB72_s0w@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 2:48 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 03/06/2013 02:44 PM, Yinghai Lu wrote:
>>
>> ok, let's stay with 2M.
>>
>
> I still want an explanation of the logic here.  What is the purpose of
> this?  Keeping the kernel page tables in large page mappable space?

yes.

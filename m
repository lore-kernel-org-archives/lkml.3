Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaKDQIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:08:52 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33041 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbaKDQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:08:47 -0500
MIME-Version: 1.0
In-Reply-To: <20141104131459.GR20550@ldesroches-Latitude-E6320>
References: <1414641641-32691-1-git-send-email-wenyou.yang@atmel.com>
	<CAPDyKFpVjoyNWpuZJ=k=nvcZkfarJtJ9oNAVjRBvmqZKuedxfA@mail.gmail.com>
	<20141104131459.GR20550@ldesroches-Latitude-E6320>
Date: Tue, 4 Nov 2014 17:00:37 +0100
Message-ID: <CAPDyKFqAZTT2mOUpKbM74ACtke=EPOCRDKj95X6YZikNxbTLvQ@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: atmel-mci: add runtime pm support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Wenyou Yang <wenyou.yang@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <chris@printf.net>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 14:14, Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
> On Tue, Nov 04, 2014 at 11:05:56AM +0100, Ulf Hansson wrote:
>> On 30 October 2014 05:00, Wenyou Yang <wenyou.yang@atmel.com> wrote:
>> > Add runtime pm support to atmel mci controller.
>> > Use runtime pm APIs to enable/disable atmel mci's clock.
>> > Use runtime autosuspend APIs to enable auto suspend delay.
>> >
>> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
>>
> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>
>> Ludovic, any objections to this one?
>
> I am not a PM runtime guru, since you have reviewed the first version,
> it is ok for me :)

Thanks! Applied for next.

Kind regards
Uffe

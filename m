Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215Ab3DCCaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:30:24 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:38183 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761168Ab3DCCaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:30:23 -0400
MIME-Version: 1.0
X-Originating-IP: [218.173.169.12]
In-Reply-To: <20130402112637.GH23065@opensource.wolfsonmicro.com>
References: <1364863193.15806.3.camel@phoenix>
	<20130402112637.GH23065@opensource.wolfsonmicro.com>
Date: Wed, 3 Apr 2013 10:30:23 +0800
Message-ID: <CAFRkauCUGM4u6wP929d-V-gKB+0N1A3M6DFoZNrsW1OeBKG2yA@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: ab8500: Fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/2 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Apr 02, 2013 at 08:39:53AM +0800, Axel Lin wrote:
>> This patch removes 'delay' field which does not exist in struct
>> ab8500_regulator_info. ( The 'delay' field was removed because fixed regulator
>> does not need to implement set_voltage_time_sel. )
>> Fix missing semicolon and declare match_size to fix below build error.
>> Also setup match pointer and match_size for ab8505 and ab8540.
>
> Lee?

Hi,
This patch does not apply to regulator tree now.
I'm sending another patch serial to fix build error.

Regards,
Axel

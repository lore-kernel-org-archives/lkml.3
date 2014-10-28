Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaJ1Sg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:36:28 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33271 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ1Sg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <f308d753cb68dc6afbfe4360c1bd4404@hardeman.nu>
References: <1413916218-7481-1-git-send-email-tomas.melin@iki.fi>
	<20141025090307.GA31078@hardeman.nu>
	<CACraW2pZnOnjj4iXoAN4A23efWVoL4ZjFXvXiS4ktxZ5YYEz9Q@mail.gmail.com>
	<f308d753cb68dc6afbfe4360c1bd4404@hardeman.nu>
Date: Tue, 28 Oct 2014 20:36:26 +0200
X-Google-Sender-Auth: fZ3roKiTYaGyRetiMESECM3jytk
Message-ID: <CACraW2rhZjmwJ0iwtfYHiYas5Kc6u_hP5JX5hDtTVnVO1uL8kQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] [media] rc-core: fix protocol_change regression in ir_raw_event_register
From: Tomas Melin <tomas.melin@iki.fi>
To: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        james.hogan@imgtec.com,
        =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
        =?UTF-8?B?0JDQu9C10LrRgdCw0L3QtNGAINCR0LXRgNGB0LXQvdC10LI=?= 
	<bay@hackerdom.ru>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:42 AM, David Härdeman <david@hardeman.nu> wrote:
> On 2014-10-26 20:33, Tomas Melin wrote:
>>
>> Please let me know your preferences on which you prefer, and, if
>> needed, I'll make a new patch version.
>
>
> I'd prefer the above, minimal, approach. But it's Mauro who decides in the
> end.
Then let's just go with that approach and see if it's ok with Mauro.

Tomas

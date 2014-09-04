Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaIDVsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:48:33 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:50785 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbaIDVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM31R+r9Qf1B50j2r1oD=WRt_bBZdHSf-0VE=V4dKEZHET_mA@mail.gmail.com>
References: <1407456558-18509-1-git-send-email-ahh@google.com>
	<CALAqxLUHt=+L4XHFqsfNnB8LExtptXkqW58vKZ4JzwN49D+hOw@mail.gmail.com>
	<CADroS=5BcPqCdgYAMfdyod1PNeYFU_qQXNYYQnoPAtB6RdCLWQ@mail.gmail.com>
	<CALAqxLWp3-BfgN_CUrvCForKNgxvsSW74WisuqT+8n6x6A=OhQ@mail.gmail.com>
	<CAPM31R+r9Qf1B50j2r1oD=WRt_bBZdHSf-0VE=V4dKEZHET_mA@mail.gmail.com>
Date: Thu, 4 Sep 2014 14:48:30 -0700
Message-ID: <CADroS=5=jEoEf9rbCHyO0XYN_fadDHVY+iWz6d5qNs-KoEvUcQ@mail.gmail.com>
Subject: Re: [PATCH] sched: fix timeval conversion to jiffies
From: Andrew Hunter <ahh@google.com>
To: Paul Turner <pjt@google.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Phil Miller <unmobile@gmail.com>,
        Aaron Jacobs <jacobsa@google.com>, Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 2:36 PM, Paul Turner <pjt@google.com> wrote:
> On Thu, Sep 4, 2014 at 2:30 PM, John Stultz <john.stultz@linaro.org> wrote:
>> This seems to be a quite old bug.. Do you think this is needed for -stable?
>
> Seems reasonable to me.
>

I have no opinion: backport or don't at your preference.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaHHMN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:13:27 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36050 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbaHHMNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAOsG7tquweEhJgctcQtN6xx0nPJsT6sB-cPNipMnETSQM-y4wA@mail.gmail.com>
References: <CAOsG7tquweEhJgctcQtN6xx0nPJsT6sB-cPNipMnETSQM-y4wA@mail.gmail.com>
Date: Fri, 8 Aug 2014 08:13:22 -0400
Message-ID: <CAC-25o-=KiyEyj_jyN=8WsbDph+f9gHWZ3aRSqQK1FLtdM8AFw@mail.gmail.com>
Subject: Re: How can I get trip index when get_trend is called ?
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hyungwoo Yang <hwoo.yang@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yang,

I am copying the list, as others may have same questions.

On Thu, Aug 7, 2014 at 7:07 PM, Hyungwoo Yang <hwoo.yang@gmail.com> wrote:
>
> Hello,
>
> My trend calculation uses trip temperature. depending on how far current
> temperature from trip point, trend is different. It worked fine but ,with DT
> support from you, I cannot find a way to get trip index for trend
> calculation.

I am not sure how the rate of temperature can be dependent on trip
temperature. Are you adding an artifact to, say, make the trend look
increasing faster if it is closer to trip temperature?

>
> Could you help me to get this? why did you change interface ? what is the
> alternative ?

Well, I do not recall changing any interface with of-thermal. The DT
support in fact adds interfaces.

Side question, what driver are you dealing with? Is it already merged
in the Linux Kernel mainline?

>
> Best Regard,
> Hyungwoo Yang



-- 
Eduardo Bezerra Valentin

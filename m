Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3J3LVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:21:22 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54082 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752574Ab3J3LVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:21:20 -0400
Message-ID: <5270EBA9.6070302@hurleysoftware.com>
Date: Wed, 30 Oct 2013 07:21:13 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Maximiliano Curia <maxy@gnuservers.com.ar>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Margarita Manterola <margamanterola@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com> <CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com> <201309030717.57866.a.miskiewicz@gmail.com> <201310241800.18490.a.miskiewicz@gmail.com> <20131029135036.GA30992@gnuservers.com.ar>
In-Reply-To: <20131029135036.GA30992@gnuservers.com.ar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 09:50 AM, Maximiliano Curia wrote:
> ¡Hola Arkadiusz!
>
> El 2013-10-24 a las 18:00 +0200, Arkadiusz Miskiewicz escribió:
>> Was just going over bug-readline and lkml archives and found no continuation
>> of this.
>
>> There was a patch proposed but didn't get applied.
>> https://lkml.org/lkml/2013/8/17/31
>> Maybe it only needs proper patch submission?
>
> The latest patch is: https://lkml.org/lkml/2013/9/3/539
>
> And the latest reply is: https://lkml.org/lkml/2013/9/11/825
>
> Where Peter Hurley suggests that the patch needs a complete and detailed
> analysis, but sadly I'm still not sure how to provide it. If anybody is up for
> the task, by all means, go ahead.

The analysis is on my TODO list. I'll include it with a proper patch, this or
next weekend.

Regards,
Peter Hurley


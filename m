Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbaISRBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:01:04 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34635 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaISRBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:01:02 -0400
MIME-Version: 1.0
In-Reply-To: <541C5F6A.1040006@odi.ch>
References: <541AE737.8070009@odi.ch>
	<CAKb7UvjcYsFm7TWzKXdWHVDVRDO1rFtcCTZoChYssDKqLMDGWw@mail.gmail.com>
	<541C40AA.4060206@odi.ch>
	<CAKb7Uvjm7vFxd-aTtuh4=XE-4JONRJgAt8n93vDHZnARsg+yiw@mail.gmail.com>
	<541C5F6A.1040006@odi.ch>
Date: Fri, 19 Sep 2014 13:01:02 -0400
X-Google-Sender-Auth: 6uRDEQ5M_V_Lj_vEWSmy1hV9a_0
Message-ID: <CAKb7Uvi_BN5WZPUA55Ma_2i5nQceryrnjJW54tCXU1hm0KVC4w@mail.gmail.com>
Subject: Re: [BUG] nouveau regression: ext monitor dead after resume
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: =?UTF-8?Q?Ortwin_Gl=C3=BCck?= <odi@odi.ch>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 12:52 PM, Ortwin Glück <odi@odi.ch> wrote:
> On 19.09.2014 17:58, Ilia Mirkin wrote:
>> git checkout 415f12efc1b2308411b2cbc3e82666b3db8a7758^
>
> Thanks again. I confirm that Bugzilla 83550 is the same issue. I have attached the captured logs
> there for reference.

Thanks! Hopefully you still have those kernels handy, as your logs got
cut off. Try booting with log_buf_len=100M to increase the
"scrollback" buffer (I assume you have oodles of RAM). Or grab the
kernel logs from your system.

  -ilia

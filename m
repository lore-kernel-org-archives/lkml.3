Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaCORxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 13:53:35 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:44732 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbaCORxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 13:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <164289036.20140315145146@eikelenboom.it>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
	<3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org>
	<1259174563.20140212120644@eikelenboom.it>
	<1335661753.20140303203853@eikelenboom.it>
	<1295963563.20140310093843@eikelenboom.it>
	<20140310150858.GA25703@tuxdriver.com>
	<EE67811F-FA2E-4773-8852-CB79BD7CDF1C@holtmann.org>
	<1679354302.20140314014901@eikelenboom.it>
	<53225B87.1030904@hurleysoftware.com>
	<164289036.20140315145146@eikelenboom.it>
Date: Sat, 15 Mar 2014 10:53:33 -0700
X-Google-Sender-Auth: zRv8OhXAxqlWYvR1ZEzc3I-Lukk
Message-ID: <CA+55aFzLGvLhF258vCWbyvXX0UOJ_tcnKaNRz_38mR5rnO6e_Q@mail.gmail.com>
Subject: Re: [RC6 Bell Chime] [PATCH 00/24] rfcomm fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 6:51 AM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
>
>
> Ok but the breakage/regression was known since around the merge window.
> I thought the "standard policy" when things cause new regression and are not fixable (too intrusive, too time consuming you
> name the reason), was to revert ..

It is indeed.

Guys, why is this being discussed? We should not release a
known-broken 3.14 just because the fix is too big for rc. Things
should be reverted.

                   Linus

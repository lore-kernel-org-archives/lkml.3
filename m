Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaIIRcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:32:18 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42084 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaIIRcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:32:16 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:f169:befe:8cc8:f71f]
In-Reply-To: <20140909121902.GA22965@amd>
References: <20140909121902.GA22965@amd>
Date: Tue, 9 Sep 2014 10:32:14 -0700
Message-ID: <CAOesGMgvqvQw2WzdQWQ7NSE_CKgH0MR-46UABkck0cQbpV4P=g@mail.gmail.com>
Subject: Re: [PATCH] fix mmc hang during boot on socfpga
From: Olof Johansson <olof@lixom.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 5:19 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> Without this patch, boot hangs when trying to mount root filesystem on
> socfpga platform in about 50% cases.

I think this should have a better description than this -- this is too
vague. Did it use to always work, is this a new failure? You enable
some more error checking and improved stop handling, why was the
previous one inadequate on this platform?


-Olof

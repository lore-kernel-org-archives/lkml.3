Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3FLJvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:51:18 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57579 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3FLJvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:51:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1306121114230.6750@pobox.suse.cz>
References: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
	<alpine.LNX.2.00.1306121114230.6750@pobox.suse.cz>
Date: Wed, 12 Jun 2013 12:51:16 +0300
Message-ID: <CAHp75Vc4UEh0MfJSv_RtED3Mbd9UUyX5M35Bi+4BvGWwQLpyAw@mail.gmail.com>
Subject: Re: [PATCH] HID: multitouch: prevent memleak with the allocated name
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 12:15 PM, Jiri Kosina <jkosina@suse.cz> wrote:

[]

> If we are going down the path of using devm API, as proposed by Andy, that
> will require much more throgough review of interaction with input
> subsystem, so definitely not a late -rc regression fix material.

Agree.

I will prepare later better approach with devm_* usage.

--
With Best Regards,
Andy Shevchenko

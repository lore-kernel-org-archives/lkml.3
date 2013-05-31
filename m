Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3EaIkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:40:07 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:38483 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3EaIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:39:59 -0400
MIME-Version: 1.0
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Date: Fri, 31 May 2013 11:39:57 +0300
Message-ID: <CAHp75VdHx7jpfeR-5=44c-M49KH3YZ+kkhNOdX+3UR-k6chW+Q@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] mrst refactoring patches
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mark.gross@intel.com, len.brown@intel.com,
        David Cohen <david.a.cohen@intel.com>, fei.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 5:45 AM, Sathyanarayanan Kuppuswamy
<sathyanarayanan.kuppuswamy@intel.com> wrote:
> As Intel rolling out more SoC's after Moorestown, we need to re-structure
> the code in a way that is backward compatible and easy to expand.This
> patch set implements a flexible way to support multiple boards and devices.
>
> Patch 1 - 5 fixes some indentation issue, compiler warnings and renames.
> Patch 6 - 13 refactors mrst code.

First of all, please, remove Gerrit IDs from the commit messages.

> Andy Shevchenko (2):
>   sfi: fix compiler warnings
>   gpiolib: append SFI helpers for GPIO API

I still insist you may move my patches before you do split to the device_lib.

Now you do some cleaning up, than split, than move to new GPIO API.
In proposed case you will have one step less.

Other comments are provided by patch.

P.S. There are new versions of my patches. One of them was published
already, I put a link in the comment, the other will be ready soon
(addressing Linus' comments).

-- 
With Best Regards,
Andy Shevchenko

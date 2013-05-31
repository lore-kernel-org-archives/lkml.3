Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3EaIY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:24:29 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44083 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3EaIYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:24:24 -0400
MIME-Version: 1.0
In-Reply-To: <1369881923-27067-12-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
	<1369881923-27067-12-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Date: Fri, 31 May 2013 11:24:23 +0300
Message-ID: <CAHp75VcnGZMOtz87YPV_zeE3Z4eXd7u1TQcSFDG1vUX+1Gdw-A@mail.gmail.com>
Subject: Re: [PATCH v1 11/13] sfi: fix compiler warnings
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mark.gross@intel.com, len.brown@intel.com,
        David Cohen <david.a.cohen@intel.com>, fei.yang@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 5:45 AM, Sathyanarayanan Kuppuswamy
<sathyanarayanan.kuppuswamy@intel.com> wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Can you use newer version [1] of this patch?

[1] https://lkml.org/lkml/2013/5/28/83

--
With Best Regards,
Andy Shevchenko

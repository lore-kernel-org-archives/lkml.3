Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaIIUED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:04:03 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33027 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaIIUEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:04:00 -0400
X-Auth-Info: 2NOsY7g+X76+DJLTfPfUmX6yO713qAjWxbFfMu3smf8=
From: Marek Vasut <marex@denx.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] fix mmc hang during boot on socfpga
Date: Tue, 9 Sep 2014 20:57:51 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20140909121902.GA22965@amd> <CAOesGMgvqvQw2WzdQWQ7NSE_CKgH0MR-46UABkck0cQbpV4P=g@mail.gmail.com>
In-Reply-To: <CAOesGMgvqvQw2WzdQWQ7NSE_CKgH0MR-46UABkck0cQbpV4P=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409092057.51839.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 09, 2014 at 07:32:14 PM, Olof Johansson wrote:
> On Tue, Sep 9, 2014 at 5:19 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Without this patch, boot hangs when trying to mount root filesystem on
> > socfpga platform in about 50% cases.
> 
> I think this should have a better description than this -- this is too
> vague. Did it use to always work, is this a new failure? You enable
> some more error checking and improved stop handling, why was the
> previous one inadequate on this platform?

+1

nit: It would also be nice if this patch contained proper mmc: tag in the 
Subject line (which applies to all other socfpga patches across all MLs).

Best regards,
Marek Vasut

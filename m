Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3CAQa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:30:27 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:49700 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3CAQaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130301135529.GB27373@kroah.com>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
 <1362098606-26469-11-git-send-email-john.stultz@linaro.org>
 <20130301020008.GB13367@kroah.com> <51302792.6040408@linaro.org>
 <CACSP8Sg=sTbJ_Yv=PdxvHQ--0_rTLN6XG3+0aFKzzHxMzVxKhw@mail.gmail.com> <20130301135529.GB27373@kroah.com>
From: Erik Gilling <konkers@android.com>
Date: Fri, 1 Mar 2013 08:30:02 -0800
X-Google-Sender-Auth: Nu_qAaLyfCpiimuxweIwAbTsp4M
Message-ID: <CACSP8SgGFtLdYDEEBapvzmn-hrCMu5VAeg2m6vjk6krw9SL8tg@mail.gmail.com>
Subject: Re: [PATCH 10/30] staging: sync: Export sync API symbols
To: Greg KH <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 5:55 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 01, 2013 at 12:21:24AM -0800, Erik Gilling wrote:
>> As John pointed out, the exynos and msm display and code uses them.  I
>> know nvidia is working on adding suport to their tegra tree.  My knee
>> jerk reaction is to make the export as permissible as possible.  That
>> being said, all of the ARM SoC vendors I've worked with have GPL
>> kernel drivers even if their user space is closed.  I'll reach out to
>> them and ask for their opinions.  Are there any issues with keeping
>> them EXPORT_SYMBOL?
>
> There's no "issues", it's just that it is preferred by some people and
> companies to add new symbols to the kernel in this manner.  It's really
> up to you / Google as you are the ones contributing the code.

Ok.  Lets keep it EXPORT_SYMBOL then.

Cheers,
   Erik

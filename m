Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab3DEXRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 19:17:49 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:62941 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760311Ab3DEXRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 19:17:47 -0400
MIME-Version: 1.0
In-Reply-To: <1365078758-28674-2-git-send-email-serban.constantinescu@arm.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
	<1365078758-28674-2-git-send-email-serban.constantinescu@arm.com>
Date: Fri, 5 Apr 2013 16:17:47 -0700
Message-ID: <CAMP5Xgd=xT7jcjz4UJY=_V8ccGLJrr6LXpkQCiR8GQCZcDPEDQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] staging: android: binder: replace explicit size types
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 5:32 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
>
> Since the binder driver uses both uint32_t and unsigned int any further
> kernel changes will be difficult to read. This patch fixes the inconsistent
> types usage.
>

Would it make more sense to only change the types that need to be
larger on a 64 bit system?

--
Arve Hjønnevåg

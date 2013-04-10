Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765536Ab3DJALT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:11:19 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53389 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219Ab3DJALS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:11:18 -0400
MIME-Version: 1.0
In-Reply-To: <1365501657-4213-2-git-send-email-serban.constantinescu@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-2-git-send-email-serban.constantinescu@arm.com>
Date: Tue, 9 Apr 2013 17:11:17 -0700
Message-ID: <CAMP5XgdPQeKBXCV5XHqkRi6NsJAhF5NdV_dEf_7gv2=GWs3v3w@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] staging: android: binder: clean-up uint32_t types
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> uint32_t types are used inconsistently throughout the driver. This patch
> replaces "uint32_t" types with "unsigned int" ones.
>

I don't like this change. You fix the header in a later patch to use
explicit sizes, so it does not make sense to do the opposite here.

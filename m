Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3B0WTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:19:14 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:61963 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3B0WTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:19:11 -0500
Date: Wed, 27 Feb 2013 14:19:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: John Stultz <john.stultz@linaro.org>
cc: lkml <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/5] staging: android: lowmemorykiller: Don't count
 reserved free memory
In-Reply-To: <1361945258-24420-3-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.02.1302271418580.7155@chino.kir.corp.google.com>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org> <1361945258-24420-3-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1026898013-1362003550=:7155"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1026898013-1362003550=:7155
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 26 Feb 2013, John Stultz wrote:

> From: Arve Hjønnevåg <arve@android.com>
> 
> The amount of reserved memory varies between devices. Subtract it
> here to reduce the amount of devices specific tuning needed for the
> minfree values.
> 
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Acked-by: David Rientjes <rientjes@google.com>
--531381512-1026898013-1362003550=:7155--

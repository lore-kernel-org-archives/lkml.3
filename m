Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3B0WSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:18:13 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53915 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3B0WSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:18:11 -0500
Date: Wed, 27 Feb 2013 14:18:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: John Stultz <john.stultz@linaro.org>
cc: lkml <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/5] staging: android: lowmemorykiller: Add config option
 to support oom_adj values
In-Reply-To: <1361945258-24420-2-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.02.1302271417000.7155@chino.kir.corp.google.com>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org> <1361945258-24420-2-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1561519083-1362003490=:7155"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1561519083-1362003490=:7155
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 26 Feb 2013, John Stultz wrote:

> From: Arve Hjønnevåg <arve@android.com>
> 
> The conversion to use oom_score_adj instead of the deprecated oom_adj
> values breaks existing user-space code. Add a config option to convert
> oom_adj values written to oom_score_adj values if they appear to be
> valid oom_adj values.
> 

Umm, writes to /proc/pid/oom_adj already are converted to the 
/proc/pid/oom_score_adj scale linearly.  Heavy NACK to this patch since 
oom_adj is completely deprecated.
--531381512-1561519083-1362003490=:7155--

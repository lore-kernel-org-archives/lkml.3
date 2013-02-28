Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3B1AOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:14:16 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:38189 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3B1AOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:14:14 -0500
Date: Wed, 27 Feb 2013 16:14:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/5] staging: android: lowmemorykiller: Add config option
 to support oom_adj values
In-Reply-To: <CAMP5XgemB4AdKEY4HFLwupo1CGv89hbmB+HUYYN8qdQRYCTdHg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302271613210.27317@chino.kir.corp.google.com>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org> <1361945258-24420-2-git-send-email-john.stultz@linaro.org> <alpine.DEB.2.02.1302271417000.7155@chino.kir.corp.google.com> <CAMP5XgcjdZk5MZ9v+W5phgWgE4Q0Pc_2FfopapjctsV6sdguLQ@mail.gmail.com>
 <alpine.DEB.2.02.1302271509230.24485@chino.kir.corp.google.com> <CAMP5XgemB4AdKEY4HFLwupo1CGv89hbmB+HUYYN8qdQRYCTdHg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1077257897-1362010453=:27317"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1077257897-1362010453=:27317
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 27 Feb 2013, Arve Hjønnevåg wrote:

> Because, without this patch, the values written to
> /sys/module/lowmemorykiller/parameters/adj do not get adjusted and
> therefore do not match the correct processes.
> 

Explain how this can possibly be consistent if your system includes two 
processes, one writing oom_adj values and one writing oom_score_adj 
values, and the kernel has this new option enabled?
--531381512-1077257897-1362010453=:27317--

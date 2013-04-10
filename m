Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3DJG0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:26:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47021 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3DJG0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:26:17 -0400
Message-ID: <516505D7.5090604@gmail.com>
Date: Wed, 10 Apr 2013 14:25:27 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Chen Gang <gang.chen@asianux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: ftrace: strncpy, using strlcpy instead
 of strncpy
References: <516243B7.9020405@asianux.com> <1365519626.25498.58.camel@gandalf.local.home>
In-Reply-To: <1365519626.25498.58.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月09日 23:00, Steven Rostedt wrote:
> I'll queue this up for my 3.10 queue. I'm going to merge this patch with
> the previous patch you sent that updates trace.c
> 
> Thanks,
> 
> -- Steve

  thanks too.


-- 
Chen Gang

Flying Transformer

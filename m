Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbaDBSAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbaDBSAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:00:52 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        eparis@redhat.com
Subject: Re: [PATCH] integrity: get comm using lock to avoid race in string printing
Date: Wed, 02 Apr 2014 14:00:23 -0400
Message-ID: <6292885.20TorKeRiK@x2>
Organization: Red Hat
User-Agent: KMail/4.12.3 (Linux/3.13.7-200.fc20.x86_64; KDE/4.12.3; x86_64; ; )
In-Reply-To: <1396460387.20325.22.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com> <1396460387.20325.22.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mimi,

On Wednesday, April 02, 2014 01:39:47 PM Mimi Zohar wrote:
> This change is already being upstreamed as commit 73a6b44 "Integrity:
> Pass commname via get_task_comm()".

While I was looking at Richard's patch, I noticed a few places where cause and 
op are logged and the string isn't tied together with a _ or -. These are in 
ima/ima_appraise.c line 383, and ima/ima_policy.c lines 333, 657, and 683. Are 
these fixed upstream? Or should a patch be made?

Thanks,
-Steve

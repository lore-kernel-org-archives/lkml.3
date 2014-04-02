Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbaDBSMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:12:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46435 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650AbaDBSMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:12:53 -0400
Message-ID: <1396462368.20325.26.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH] integrity: get comm using lock to avoid race in string
 printing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        eparis@redhat.com
Date: Wed, 02 Apr 2014 14:12:48 -0400
In-Reply-To: <6292885.20TorKeRiK@x2>
References: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com>
	 <1396460387.20325.22.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <6292885.20TorKeRiK@x2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040218-1344-0000-0000-000000AA3961
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 14:00 -0400, Steve Grubb wrote: 
> Hello Mimi,
> 
> On Wednesday, April 02, 2014 01:39:47 PM Mimi Zohar wrote:
> > This change is already being upstreamed as commit 73a6b44 "Integrity:
> > Pass commname via get_task_comm()".
> 
> While I was looking at Richard's patch, I noticed a few places where cause and 
> op are logged and the string isn't tied together with a _ or -. These are in 
> ima/ima_appraise.c line 383, and ima/ima_policy.c lines 333, 657, and 683. Are 
> these fixed upstream? Or should a patch be made?

Nothing has changed in terms of 'cause' and 'op'.  I would suggest
making the changes in integrity_audit.c: integrity_audit_msg().

thanks,

Mimi



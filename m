Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaCYNDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:03:01 -0400
Received: from mail.cs.hku.hk ([147.8.176.10]:46824 "EHLO mail.cs.hku.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaCYNDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:03:00 -0400
Message-ID: <20140325210229.111429rui2btlz8k@intranet.cs.hku.hk>
Date: Tue, 25 Mar 2014 21:02:29 +0800
From: lwcheng@cs.hku.hk
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Question] Linux CFS sched_entity
References: <20140317125541.17043cxzmlnxa0ys@intranet.cs.hku.hk>
 <20140325114936.GA29592@e103034-lin>
In-Reply-To: <20140325114936.GA29592@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.4)
X-cs-MailScanner-Information: Please contact the ISP for more information
X-cs-MailScanner-ID: s2PD2UNS003553
X-cs-MailScanner: Found to be clean
X-cs-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.535,
	required 6, autolearn=disabled, ALL_TRUSTED -1.00,
	RP_MATCHES_RCVD -0.54)
X-cs-MailScanner-From: lwcheng@cs.hku.hk
X-cs-MailScanner-Watermark: 1396357353.60154@3rKwY77wHLf4Kc9RTQUcpw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Morten Rasmussen <morten.rasmussen@arm.com>:

> On Mon, Mar 17, 2014 at 04:55:41AM +0000, lwcheng@cs.hku.hk wrote:
>> In what situations does cfs_rq->curr point to a task_group?
>> What's the sense? I thought it should always contain a "real" task.
>
> In nested task groups cfs_rq->curr may point to a sched_entity which is
> a nested task group (cfs_rq).
>
> parent_group -> child_group -> task
>
> Morten

Thanks for your reply.

Luwei




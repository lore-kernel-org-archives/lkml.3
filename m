Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaBGVL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:11:57 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42257 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbaBGVLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:11:55 -0500
Message-ID: <52F54C04.4010807@cs.wisc.edu>
Date: Fri, 07 Feb 2014 15:11:32 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: Michele Baldessari <michele@acksyn.org>
CC: open-iscsi@googlegroups.com, trivial@kernel.org, chorn@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the arguments order of a few iscsi_conn_printk()
 calls
References: <1391789933-15062-1-git-send-email-michele@acksyn.org>
In-Reply-To: <1391789933-15062-1-git-send-email-michele@acksyn.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 10:18 AM, Michele Baldessari wrote:
> A few places had the opcode and itt arguments reversed.
> Fix the order.
> 
> Reported-by: Josef Moellers <josef.moellers@ts.fujitsu.com>
> Signed-off-by: Michele Baldessari <michele@acksyn.org>


Thanks. I just acked a patch to do the same:
https://lkml.org/lkml/2014/1/8/754

Have you been hitting that code and with what target and what type of
command?


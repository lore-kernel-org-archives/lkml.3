Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab3BMUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:01:38 -0500
Received: from mail.tpi.com ([70.99.223.143]:2973 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093Ab3BMUBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:01:37 -0500
Message-ID: <511BF11C.6070100@canonical.com>
Date: Wed, 13 Feb 2013 13:01:32 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Tim Gardner <tim.gardner@canonical.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 1/2 linux-next] ocfs2: remove kfree() redundant null checks
References: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 12:44 PM, Tim Gardner wrote:
> fs/ocfs2/alloc.c:6138 ocfs2_begin_truncate_log_recovery() info:
>  redundant null check on *tl_copy calling kfree()

Ignore this series. I'll resend.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

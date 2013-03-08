Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab3CHN07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:26:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab3CHN06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:26:58 -0500
Date: Fri, 8 Mar 2013 14:26:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: syamsidhardh@gmail.com
Cc: linux-kernel@vger.kernel.org, jslaby@suse.cz, gregkh@linuxfoundation.org,
        Syam Sidhardhan <s.syam@samsung.com>
Subject: Re: [PATCH v1] tty: ipwireless: Remove redundant NULL check before
 kfree
In-Reply-To: <1362601044-6228-1-git-send-email-s.syam@samsung.com>
Message-ID: <alpine.LRH.2.00.1303081425410.7777@twin.jikos.cz>
References: <1362601044-6228-1-git-send-email-s.syam@samsung.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013, syamsidhardh@gmail.com wrote:

> From: Syam Sidhardhan <s.syam@samsung.com>
> 
> kfree on NULL pointer is a no-op.
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>

With my ipwireless maintainer hat on:

	Acked-by: Jiri Kosina <jkosina@suse.cz>

Greg, could you please take it through tty tree?

Thanks,

-- 
Jiri Kosina
SUSE Labs


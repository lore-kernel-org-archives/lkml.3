Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab3HMRfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:35:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33709 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759064Ab3HMRfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:35:50 -0400
Message-ID: <1376415349.1949.40.camel@joe-AO722>
Subject: Re: [PATCH 09/10] staging: ozwpan: Swap arguments of oz_ep_alloc()
 to match kmalloc()
From: Joe Perches <joe@perches.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, dan.carpenter@oracle.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Tue, 13 Aug 2013 10:35:49 -0700
In-Reply-To: <1376414966-23525-5-git-send-email-rupesh.gujare@atmel.com>
References: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
	 <1376414966-23525-5-git-send-email-rupesh.gujare@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 18:29 +0100, Rupesh Gujare wrote:
> Swap arguments of oz_ep_alloc() to match kmalloc() for better readability.
[]
> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
[]
> -static struct oz_endpoint *oz_ep_alloc(gfp_t mem_flags, int buffer_size)
> +static struct oz_endpoint *oz_ep_alloc(int buffer_size, gfp_t mem_flags)

could use size_t buffer_size instead.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaFEOJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:09:47 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38119 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFEOJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:09:45 -0400
Message-ID: <53907A30.5030905@cogentembedded.com>
Date: Thu, 05 Jun 2014 18:09:52 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>
CC: Krzysztof Opasiak <k.opasiak@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: gadget: f_fs: resurect usb_functionfs_descs_head
 structure
References: <1401954206-8491-1-git-send-email-mina86@mina86.com>
In-Reply-To: <1401954206-8491-1-git-send-email-mina86@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/05/2014 11:43 AM, Michal Nazarewicz wrote:

> Even though usb_functionfs_descs_head structure is now deprecated,
> it has been used by some user space tools.  It's removel in commit

    s/It's removel/Its removal/.

> [ac8dde1: Add flags to descriptors block] was an oversight leading
> to build breakage for such tools.

> Bring it back so that old user space tools can still be build
> without problems on newer kernel versions.

> Cc: <stable@vger.kernel.org>  # 3.14
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

WBR, Sergei


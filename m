Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab3EWWm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 18:42:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45636 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759799Ab3EWWm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 18:42:56 -0400
Message-ID: <1369348974.2075.52.camel@joe-AO722>
Subject: Re: [PATCH 1/7] staging/silicom/bypasslib: Reformat comments
From: Joe Perches <joe@perches.com>
To: Lisa Nguyen <lisa@xenapiadmin.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Thu, 23 May 2013 15:42:54 -0700
In-Reply-To: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
References: <8f0a1b9dd2524047034345709cb11102ca44eded.1369342182.git.lisa@xenapiadmin.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-23 at 13:51 -0700, Lisa Nguyen wrote:
> Resolved the C99 comment style issue by reformatting existing comments 
> to meet kernel coding standards in bp_ioctl.h
[]
> diff --git a/drivers/staging/silicom/bypasslib/bp_ioctl.h b/drivers/staging/silicom/bypasslib/bp_ioctl.h
[]
> -#define BP_CAP                   0x01	//BIT_0
[...]
> +#define BP_CAP                   0x01	/* BIT_0 */

Better to use the more self-documenting

#define BP_CAP		BIT(0)

etc...  with out any comment at all.



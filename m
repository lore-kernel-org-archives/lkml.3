Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaEHOXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:23:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaEHOXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:23:49 -0400
Date: Thu, 8 May 2014 10:23:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: hpa@zytor.com
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86/boot: Small string.c cleanups
Message-ID: <20140508142348.GE9224@redhat.com>
References: <1398447972-27896-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398447972-27896-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Can you please include these small cleanup fixes. Please do let me know
if you have any concerns.

Thanks
Vivek

On Fri, Apr 25, 2014 at 01:46:10PM -0400, Vivek Goyal wrote:
> Hi Hpa,
> 
> Here are two more small cleanups to boot/string.c code. This makes 
> inclusion of boot/string.c at other places even simpler.
> 
> Thanks
> Vivek
> 
> Vivek Goyal (2):
>   x86/boot: Do not include boot.h in string.c
>   x86/boot: Remove misc.h inclusion from compressed/string.c
> 
>  arch/x86/boot/compressed/string.c | 4 ----
>  arch/x86/boot/string.c            | 9 ++-------
>  2 files changed, 2 insertions(+), 11 deletions(-)
> 
> -- 
> 1.9.0

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaJDMiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 08:38:46 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:47675 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaJDMio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 08:38:44 -0400
Date: Sat, 4 Oct 2014 07:38:39 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3.16 000/357] 3.16.4-stable review
Message-ID: <20141004073839.125fa529@as>
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Oct 2014 14:26:26 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> ---------------------------------
> Note: This is a big stable release.  Mostly my fault for being on the
> road last week, combined with an unusually large number of patches being
> tagged for the stable tree.  Anyway, I've caught up with all pending
> patches before 3.17-rc7, so if you have marked something for the stable
> tree that I have not applied, or emailed the stable@v.k.o list asking
> for a patch, that is not here, please let me know.
> ---------------------------------
> 
> This is the start of the stable review cycle for the 3.16.4 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun Oct  5 21:28:42 UTC 2014.
> Anything received after that time might be too late.
> 

Should also include this one, which fixes CVE-2014-6410:

commit c03aa9f6e1f938618e6db2e23afef0574efeeb65
Author: Jan Kara <jack@suse.cz>
Date:   Thu Sep 4 14:06:55 2014 +0200

    udf: Avoid infinite loop when processing indirect ICBs



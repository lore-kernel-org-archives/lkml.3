Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3J0Xzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 19:55:53 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:65158 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3J0Xzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 19:55:52 -0400
Date: Sun, 27 Oct 2013 19:55:48 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] Staging: bcm: Replace UCHAR with unsigned char in
 Adapter.h
Message-ID: <20131027235547.GA3191@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
 <1382768120-23380-4-git-send-email-klmckinney1@gmail.com>
 <20131027082555.GM5871@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027082555.GM5871@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 11:25:55AM +0300, Dan Carpenter wrote:
> On Sat, Oct 26, 2013 at 02:15:13AM -0400, Kevin McKinney wrote:
> > This patch replace "UCHAR" with "unsigned
> > char" in Adapter.h
> 
> I feel like these should pretty much all be u8 instead of "unsigned
> char".

Yeah, I thought about changing these to u8. I will resubmit these 11 patches.

Thanks,
Kevin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3BORed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:34:33 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39513 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378Ab3BOReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:34:31 -0500
X-Sasl-enc: xhtGV7wtuAUIesRXAEfUr7jWaP904miTTCNg9W2gCvqN 1360949670
Date: Fri, 15 Feb 2013 09:34:29 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Stevenson <david@avoncliff.com>
Subject: Re: linux-next: build warning after merge of the char-misc tree
Message-ID: <20130215173429.GA27707@kroah.com>
References: <20130215162657.6dd03d27e8cfed0c134b5dd3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215162657.6dd03d27e8cfed0c134b5dd3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 04:26:57PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the char-misc tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/w1/slaves/w1_therm.c: In function 'w1_therm_read':
> drivers/w1/slaves/w1_therm.c:245:15: warning: 'crc' may be used uninitialized in this function [-Wuninitialized]
> 
> Its a false positive, but it was introduced by commit 867ff9880d5d
> ("w1_therm: Retries: remove old code add CRC")

I don't see that here with gcc 4.7.1, perhaps you need to upgrade your
version of gcc to not show these false positives?

thanks,

greg k-h

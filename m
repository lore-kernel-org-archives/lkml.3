Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3FDUWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:22:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3FDUWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:22:42 -0400
Message-ID: <51AE4C54.6000709@infradead.org>
Date: Tue, 04 Jun 2013 13:21:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: Tree for Jun 4 (pch_phub.c)
References: <20130604174107.99848a1dbb2532ceffe993eb@canb.auug.org.au>
In-Reply-To: <20130604174107.99848a1dbb2532ceffe993eb@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/13 00:41, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130603:
> 

when CONFIG_NET is not enabled:

ERROR: "mac_pton" [drivers/misc/pch_phub.ko] undefined!


-- 
~Randy

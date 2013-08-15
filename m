Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab3HORHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:07:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58589 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716Ab3HORHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:07:41 -0400
Message-ID: <520D0AD7.6050002@infradead.org>
Date: Thu, 15 Aug 2013 10:07:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 15 (usb/phy/phy-am335x-control.c)
References: <20130815165829.6a401f104ee2a98dd48bcb58@canb.auug.org.au>
In-Reply-To: <20130815165829.6a401f104ee2a98dd48bcb58@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/13 23:58, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130814:
> 

on i386 and x86_64:

drivers/usb/phy/phy-am335x-control.c:45:3: error: implicit declaration of function '__WARN' [-Werror=implicit-function-declaration]


-- 
~Randy

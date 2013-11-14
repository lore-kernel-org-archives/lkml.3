Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3KNTFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:05:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34790 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3KNTE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:04:56 -0500
Message-ID: <52851EBC.9010803@infradead.org>
Date: Thu, 14 Nov 2013 11:04:28 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, peng tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        andreas.dilger@intel.com, hpdd-discuss <hpdd-discuss@ml01.01.org>
Subject: Re: linux-next: Tree for Nov 14 (lustre)
References: <20131114152253.105a4978427b3cd0555ee877@canb.auug.org.au>
In-Reply-To: <20131114152253.105a4978427b3cd0555ee877@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13 20:22, Stephen Rothwell wrote:
> Hi all,
> 
> Please do *not* add any v3.14 material to linux-next until after
> v3.13-rc1 is released.
> 
> Changes since 20131113:
> 

Please fix MANY build errors that show up when CONFIG_PROC_FS is not enabled.

thanks.
-- 
~Randy

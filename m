Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297Ab3DDVDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:03:18 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:26217 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762862Ab3DDVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:03:17 -0400
Message-ID: <515DCE6D.7080203@free.fr>
Date: Thu, 04 Apr 2013 21:03:09 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
Organization: Chez moi
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: Strange trace in dmesg on kernel 3.8.5
References: <515DD32F.3030509@free.fr> <20130404194404.GA8082@pd.tnic> <1365108338.3072.3.camel@shinybook.infradead.org>
In-Reply-To: <1365108338.3072.3.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 22:45, David Woodhouse wrote:
> On Thu, 2013-04-04 at 21:44 +0200, Borislav Petkov wrote:
>>> ahci 0000:00:1f.2: DMA-API: device driver maps memory fromstack
>>> [addr=ffff88040df2da50]
> I fixed this already. 
>
> https://git.kernel.org/cgit/linux/kernel/git/jgarzik/libata-dev.git/commit/?h=upstream-fixes&id=8e725c7f8a60feaa88edacd4dee2c754d5ae7706
>
Thanks for the support. I will apply the patch manually and wait for 3.8.6

-- eric
 


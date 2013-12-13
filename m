Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3LMN4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:56:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab3LMN4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:56:12 -0500
Date: Fri, 13 Dec 2013 14:56:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Emanuel Krenz <emanuelkrenz@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-multitouch: add support for SiS panel in LG
 23ET83V
In-Reply-To: <trinity-1ba34dee-30ba-4815-8f91-cbeb762f4b32-1386941992832@3capp-webde-bs44>
Message-ID: <alpine.LNX.2.00.1312131455440.12702@pobox.suse.cz>
References: <trinity-1ba34dee-30ba-4815-8f91-cbeb762f4b32-1386941992832@3capp-webde-bs44>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Emanuel Krenz wrote:

> I bought an LG 23ET83V multitouch monitor, whose idProduct=1030 wasn't 
> yet included in the hid-multitouch driver. So I wrote following patch to 
> include the ID number 1030 and patched the latest stable 3.12.5 kernel. 
> The SiS touchpanel in my monitor works for me now. This is my first 
> submitted patch, hope it's okay now, ...well every beginning is 
> difficult ;-).

Now applied (after refreshing it to apply on top of the SIS quirk 
merging). Thanks,

-- 
Jiri Kosina
SUSE Labs

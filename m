Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3LMNNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:13:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3LMNNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:13:13 -0500
Date: Fri, 13 Dec 2013 14:13:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Emanuel Krenz <emanuelkrenz@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-multitouch: add support for SiS panel in LG
 23ET83V
In-Reply-To: <52AAE4FE.6090000@web.de>
Message-ID: <alpine.LNX.2.00.1312131409580.12702@pobox.suse.cz>
References: <52AAE4FE.6090000@web.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Emanuel Krenz wrote:

> From: Emanuel Krenz <emanuelkrenz@web.de>
> 
> Add support for SiS multitouch panel in the touch monitor LG 23ET83V.
> 
> I bought an LG 23ET83V multitouch monitor, whose idProduct=1030 wasn't 
> yet included in the hid-multitouch driver. So I wrote following patch to 
> include the ID number 1030 and patched the latest stable 3.12.5 kernel. 
> The SiS touchpanel in my monitor works for me now. This is my first 
> submitted patch by now, hope it's okay.

Hi Emanuel

This time it doesn't have any Signed-off-by: line, but you should actually 
include your own :)

Also, your mail clinet unfortunately corrupted (line-wrapped) the patch, 
so that it can't be applied. Please fix your mail client so that it 
doesn't corrupt patches -- there are some hints in 
Documentation/email-clients.txt

Thanks,

-- 
Jiri Kosina
SUSE Labs

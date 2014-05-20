Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaETLy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:54:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51687 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbaETLy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:54:27 -0400
Date: Tue, 20 May 2014 12:54:21 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: kernel 3.14.2 oops: seems related to EFI
Message-ID: <20140520115421.GH4798@console-pimps.org>
References: <53777F7B.8060407@gmail.com>
 <20140518134206.GA8040@pd.tnic>
 <5379AE46.3000407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5379AE46.3000407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May, at 09:09:58AM, Francis Moreau wrote:
> 
> I don't know, I can't really afford to configure/compile/test this new
> kernel, sorry.

It would be useful to know whether this issue still occurs when booting
with the efi=old_map kernel parameter.

-- 
Matt Fleming, Intel Open Source Technology Center

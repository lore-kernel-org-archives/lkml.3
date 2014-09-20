Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaITR0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:26:30 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43873 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaITR03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:26:29 -0400
Message-ID: <541DB8C1.2000101@gmail.com>
Date: Sat, 20 Sep 2014 13:26:25 -0400
From: nick <yocto6@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: julia.lawall@lip6.fr, oneukum@suse.de, himangi774@gmail.com,
        stern@rowland.harvard.edu, paul.gortmaker@windriver.com,
        peter.chen@freescale.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: FIX ME in  oxu210p-hcd.c
References: <541DB6BF.7090909@gmail.com>
In-Reply-To: <541DB6BF.7090909@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found a unfixed FIX ME in the file stated in my above message. I am wondering what to set hcd->self.comtroller->dma_mask 
to as it's now been defined to NULL and clearly even as a newbie this seem incorrect.
Regards Nick  


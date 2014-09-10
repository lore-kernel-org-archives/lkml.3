Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaIJDCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:02:30 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64991 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaIJDC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:02:29 -0400
Message-ID: <540FA96D.7040903@gmail.com>
Date: Wed, 10 Sep 2014 03:29:17 +0200
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: octeon-hcd: removed dummy label
References: <1410276139-7212-1-git-send-email-nitinkuppelur@gmail.com> <20140909190200.GT6600@mwanda>
In-Reply-To: <20140909190200.GT6600@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Sorry for that. While doing some last movement changes
related to indentation I accidentally removed the brace
and did not build it after :-(

I am sending PATCH with correction.

Regards,
Nitin


> 
> Wat?  Does this still compile without the curly brace?
> 
> regards,
> dan carpenter
> 

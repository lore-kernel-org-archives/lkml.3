Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaEQIDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 04:03:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40287 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbaEQIC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 04:02:57 -0400
Date: Sat, 17 May 2014 10:56:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Son P. Nguyen" <fastmutex@gmail.com>
Cc: w.d.hubbs@gmail.com, devel@driverdev.osuosl.org, kirk@reisers.ca,
        speakup@braille.uwo.ca, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, samuel.thibault@ens-lyon.org,
        chris@the-brannons.com
Subject: Re: [PATCH] Staging: speakup: fixed reporting_keystroke variable type
Message-ID: <20140517075632.GJ8897@mwanda>
References: <1400287603-9362-1-git-send-email-fastmutex@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400287603-9362-1-git-send-email-fastmutex@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 12:46:43AM +0000, Son P. Nguyen wrote:
> From: "Son P. Nguyen" <fastmutex@gmail.com>
> 
> Fixed reporting_keystroke type to int instead of bool to quiet sparse
> complaints of error cannot size expression.
> 
> This is a part of eudyptula-challenge.
> 

This is a bug in Sparse.  The original code is correct.

regards,
dan carpenter


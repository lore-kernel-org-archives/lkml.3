Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937AbaEQS4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 14:56:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20501 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaEQS4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 14:56:31 -0400
Date: Sat, 17 May 2014 21:56:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masood Mehmood <ody.guru@gmail.com>
Subject: Re: [PATCH] Fix for possible null pointer dereference in node.c
Message-ID: <20140517185615.GB15585@mwanda>
References: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140515224327.GA16255@mwanda>
 <CAFo99gYEf6GrAjuWNc5+DEEuBV82eejRuy7QtiJuLD+sRccLRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gYEf6GrAjuWNc5+DEEuBV82eejRuy7QtiJuLD+sRccLRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 03:21:56PM +0200, Rickard Strandqvist wrote:
> Okay, everyone agrees with Dan..?
> 

You can audit it yourself, there are only 4 callers.  The
node_allocate() is total garbage so the second delete_node() is a bit
complicated to read but it's not that hard.

> I have made a new patch, which does not check if hnode is NULL.

Send it inline so we can use our normal scripts.

regards,
dan carpenter


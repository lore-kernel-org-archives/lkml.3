Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaEOWnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:43:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34340 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaEOWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:43:44 -0400
Date: Fri, 16 May 2014 01:43:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masood Mehmood <ody.guru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for possible null pointer dereference in node.c
Message-ID: <20140515224327.GA16255@mwanda>
References: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:53:53PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 

None of the callers pass in a NULL hnode so there isn't actually a NULL
dereference here.  You could just remove the check.

regards,
dan carpenter


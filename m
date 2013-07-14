Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3GNXIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:08:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:40729 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab3GNXGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:51 -0400
Message-ID: <1373843199.19894.302.camel@pasglop>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 09:06:39 +1000
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
References: <20130711214830.611455274@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 15:01 -0700, Greg Kroah-Hartman wrote:
> s is the start of the stable review cycle for the 3.10.1 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Sat Jul 13 21:45:35 UTC 2013.
> Anything received after that time might be too late.

And you expect that we all have time to dig that out from lkml in 1
day ? You have a rant about powerpc and don't CC me ? :-)

This one is really important/urgent:

74251fe21bfa9310ddba9e0436d1fcf389e602ee
"powerpc/powernv: Fix iommu initialization again"

Cheers,
Ben.



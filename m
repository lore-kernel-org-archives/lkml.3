Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3LCDDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:03:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3LCDDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:03:19 -0500
Date: Mon, 2 Dec 2013 19:04:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/60] 3.4.72-stable review
Message-ID: <20131203030420.GA26355@kroah.com>
References: <20131202190330.152596462@linuxfoundation.org>
 <529D4705.1000100@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529D4705.1000100@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 06:50:45PM -0800, Guenter Roeck wrote:
> On 12/02/2013 11:05 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.72 release.
> > There are 60 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Dec  4 19:01:45 UTC 2013.
> > Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 103 pass: 89 skipped: 10 fail: 4
> 
> qemu tests all passed. Results are as expected.

Great, thanks for testing.

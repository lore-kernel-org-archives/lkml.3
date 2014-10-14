Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaJND1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 23:27:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaJND1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 23:27:10 -0400
Date: Tue, 14 Oct 2014 05:26:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Message-ID: <20141014032607.GA28769@kroah.com>
References: <20141013022454.289398272@linuxfoundation.org>
 <543BED9C.20404@roeck-us.net>
 <20141014023911.GB27498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014023911.GB27498@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:39:11AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Oct 13, 2014 at 08:19:56AM -0700, Guenter Roeck wrote:
> > On 10/12/2014 07:24 PM, Greg Kroah-Hartman wrote:
> > >This is the start of the stable review cycle for the 3.17.1 release.
> > >There are 25 patches in this series, all will be posted as a response
> > >to this one.  If anyone has any issues with these being applied, please
> > >let me know.
> > >
> > >Responses should be made by Wed Oct 15 02:24:45 UTC 2014.
> > >Anything received after that time might be too late.
> > >
> > 
> > Build results:
> > 	total: 134 pass: 134 fail: 0
> > 
> > Qemu test results:
> > 	total: 30 pass: 30 fail: 0
> > 
> > Details are available at http://server.roeck-us.net:8010/builders.
> 
> Thanks for testing all 3 of these and letting me know.

All 4, sorry...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab3K0RPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:15:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab3K0RPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:15:10 -0500
Date: Wed, 27 Nov 2013 12:11:37 -0500
From: Dave Jones <davej@redhat.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: staging: comedi: Fix boolean/logical and mix-up.
Message-ID: <20131127171137.GA7504@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hartley Sweeten <HartleyS@visionengravers.com>,
	"dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131107062754.93B2D660F4A@gitolite.kernel.org>
 <20131108200659.GA2101@redhat.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8817E08AC5@P3PWEX4MB008.ex4.secureserver.net>
 <20131127025724.GA18860@redhat.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8817E0BBCA@P3PWEX4MB008.ex4.secureserver.net>
 <DC148C5AA1CEBA4E87973D432B1C2D8817E0CCFC@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8817E0CCFC@P3PWEX4MB008.ex4.secureserver.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 04:59:17PM +0000, Hartley Sweeten wrote:
 
 > > Added Greg KH and the staging devel list to the CCs.
 > 
 > I just noticed that Dan Carpenter already submitted a patch that fixed this.
 > It was merged as commit 9382c06e2d192adec090fb09ff0b699e951f88e1.

Ah, I didn't look at -next.

thanks,

	Dave


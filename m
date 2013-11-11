Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3KKNHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:07:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24506 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3KKNGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:06:51 -0500
Date: Mon, 11 Nov 2013 16:06:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCHv2] staging: go7007: fix use of uninitialised pointer
Message-ID: <20131111130634.GH5302@mwanda>
References: <1384108677-23476-1-git-send-email-mpn@google.com>
 <20131110185210.GA9633@kroah.com>
 <87fvr480o9.fsf@mina86.com>
 <20131110210647.GA5302@mwanda>
 <xa1tzjpbxisv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xa1tzjpbxisv.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 12:46:24PM +0100, Michal Nazarewicz wrote:
> go variable is initialised only after the switch case so it cannot be
> dereferenced prior to that happening.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Looks good.  Thanks.  :)

regards,
dan carpenter


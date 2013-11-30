Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3K3WFB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:05:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3K3WE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:04:57 -0500
Date: Sat, 30 Nov 2013 14:05:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        pali.rohar@gmail.com, sre@ring0.de, omar.ramirez@copitl.com,
        tony@atomide.com, felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com,
        ohad@wizery.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        nico@ngolde.de
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not a
 security problem
Message-ID: <20131130220553.GA1901@kroah.com>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
 <20131130191931.GA5286@amd.pavel.ucw.cz>
 <20131130194935.GG5443@mwanda>
 <20131130204237.GA17912@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130204237.GA17912@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 09:42:37PM +0100, Pavel Machek wrote:
> 
> mmap in tidspbridge is missing range-checks. For now, make this
> interface root-only, so that it does not cause security problems.

Please fix this properly and don't paper over the real problem here.

thanks,

greg k-h

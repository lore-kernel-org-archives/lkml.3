Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3LAT2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 14:28:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51394 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3LAT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 14:28:52 -0500
Date: Sun, 1 Dec 2013 22:28:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Pali =?iso-8859-1?Q?Roh=E1?= <pali.rohar@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU?= <freemangordon@abv.bg>, sre@ring0.de,
        omar.ramirez@copitl.com, tony@atomide.com, felipe.contreras@gmail.com,
        s-anna@ti.com, nm@ti.com, ohad@wizery.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, nico@ngolde.de
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not a
 security problem
Message-ID: <20131201192821.GJ5443@mwanda>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
 <20131130220553.GA1901@kroah.com>
 <20131130225822.GA26031@amd.pavel.ucw.cz>
 <201312011041.40071@pali>
 <1385891913.11457.2.camel@Nokia-N900>
 <20131201121006.GA26072@amd.pavel.ucw.cz>
 <20131201122756.GH5443@mwanda>
 <529B7C8D.7060101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529B7C8D.7060101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

regards,
dan carpenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbbASU1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:27:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49931 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbbASU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:27:43 -0500
Date: Mon, 19 Jan 2015 23:26:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: shirish gajera <gajerashirish@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, kirk@reisers.ca,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg KH <gregkh@linuxfoundation.org>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Robin Schroer <sulamiification@gmail.com>, speakup@linux-speakup.org,
        =?utf-8?Q?Ay=C5=9Fe_Melike_Yurto=C4=9Flu?= 
	<aysemelikeyurtoglu@gmail.com>,
        linux-kernel@vger.kernel.org,
        Domagoj =?utf-8?B?VHLFoWFu?= <domagoj.trsan@gmail.com>,
        Roxana Blaj <roxanagabriela10@gmail.com>, tapaswenipathak@gmail.com,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dilek =?iso-8859-1?Q?=DCz=FClmez?= <dilekuzulmez@gmail.com>,
        sasha.levin@oracle.com, Christopher Brannon <chris@the-brannons.com>
Subject: Re: [PATCH] staging: speakup: Fix warning of line over 80 characters.
Message-ID: <20150119202638.GC6507@mwanda>
References: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
 <1421574950.31046.97.camel@decadent.org.uk>
 <20150119122539.GC6456@mwanda>
 <CAG77vrrbEmw7OR8N7bcmKEkDwXonsfmJeE6-epYxSMLT5uQpMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG77vrrbEmw7OR8N7bcmKEkDwXonsfmJeE6-epYxSMLT5uQpMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:00:34PM -0800, shirish gajera wrote:
> I am confuse whether to wait till the patch got accepted or submit new
> patch set.

Just wait for Greg to get to the patch.  We pretty much always apply
long line fixes so just assume it's going to merged.

> 
> Also, how to identify whether the corresponding warning is real or not ?

It's all a matter of personal taste.  The end code should look better
than the original code.  I thought your changes looked pretty good...

regards,
dan carpenter


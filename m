Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3CFHx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:53:27 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:62600 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758Ab3CFHxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:53:25 -0500
Message-ID: <1362556402.16460.158.camel@x61.thuisdomein>
Subject: Re: [PATCH] remoteproc: properly fix missing CONFIG_FW_LOADER
 configurations
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, stable <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Mar 2013 08:53:22 +0100
In-Reply-To: <20130306004609.GB28448@kroah.com>
References: <1362511248.16460.113.camel@x61.thuisdomein>
	 <20130305215408.GD10965@kroah.com>
	 <1362522169.16460.151.camel@x61.thuisdomein>
	 <20130306004609.GB28448@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2013 07:53:23.0143 (UTC) FILETIME=[AD33AD70:01CE1A3F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 08:46 +0800, Greg KH wrote:
> On Tue, Mar 05, 2013 at 11:22:49PM +0100, Paul Bolle wrote:
> > 1) But actually thinking about this: that upstream commit did end up in
> > the (longterm) v3.4.y series. And my patch is also relevant for the
> > v3.8.y series.
> 
> As that patch was in the 3.5-rc7 release, how can it be relevant for
> 3.8, or anything greater than 3.5 at all?

I seem to have confused you. My patch fixes a bug caused by a commit
that shipped in final release v3.5 (and is also part the 3.4.y series,
because that commit got added to that stable series).

> > Can't this patch, that fixes an obviously bogus commit,
> > which was important enough for stable, be itself submitted with
> > CC:stable?
> 
> How can you expect me to apply something that is already in the tree?  :)

It's not (yet) in the tree but fixes something that is in the tree. 


Paul Bolle


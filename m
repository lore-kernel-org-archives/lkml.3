Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaIFAeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:34:01 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44090 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaIFAeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:34:00 -0400
Date: Fri, 5 Sep 2014 19:33:54 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Arne Wiebalck <Arne.Wiebalck@cern.ch>
Cc: Peter Kieser <peter@kieser.ca>, "eddie@ehuk.net" <eddie@ehuk.net>,
        "Jens Axboe" <axboe@kernel.dk>,
        Francis Moreau <francis.moro@gmail.com>,
        "Kent Overstreet" <kmo@daterainc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
Message-ID: <20140905193354.4a123a4c@as>
In-Reply-To: <F71A0899-EF6F-44A3-B207-E1DACC8721B6@cern.ch>
References: <20140805043346.GF541@moria.home.lan>
	<53E10D48.1010700@kernel.dk>
	<53E7251B.3080305@kieser.ca>
	<540966BA.9030106@gmail.com>
	<5409C5FC.6020406@kernel.dk>
	<5409D8BC.7030003@ehuk.net>
	<5409E7AB.7040704@kieser.ca>
	<F71A0899-EF6F-44A3-B207-E1DACC8721B6@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014 17:03:57 +0000
Arne Wiebalck <Arne.Wiebalck@cern.ch> wrote:

> 
> On Sep 5, 2014, at 6:41 PM, Peter Kieser <peter@kieser.ca>
>  wrote:
> 
> > 
> > On 2014-09-05 8:37 AM, Eddie Chapman wrote:
> >> On 05/09/14 15:17, Jens Axboe wrote:
> >>> (from oldest to newest). And that's just from 3.16 to 3.17-rc3,
> >>> going all the way back to 3.10 would be a lot of work. If there's
> >>> anyone that cares about bcache on stable kernels (and actually
> >>> use it), now would be a good time to pipe up.
> >> 
> >> Just "piping up" as I care about bcache and actually use it in
> >> production on 3.10! Shame I don't have the knowledge to try and
> >> backport these though :-)
> >> 
> >> Eddie
> > 
> > I'm "piping up" as well, I use bcache on 3.10 in production.
> > 
> > -Peter
> > 
> 
> 
> More "piping up": we currently use bcache on a few nodes in
> production, on 3.14 and 3.15, and plan to roll it out on a wider
> scale now. If necessary we'll go with these kernels, but we'd
> certainly prefer our usual 3.10-based CentOS kernel.
> 

CentOS does not ship bcache at all. In retrospect it's obvious why.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaIEPm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:42:59 -0400
Received: from mail.steelbluetech.co.uk ([109.169.51.66]:31965 "EHLO
	mail.steelbluetech.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaIEPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:42:55 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 11:42:54 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.steelbluetech.co.uk s85FbWCn037497
Message-ID: <5409D8BC.7030003@ehuk.net>
Date: Fri, 05 Sep 2014 16:37:32 +0100
From: Eddie Chapman <eddie@ehuk.net>
Reply-To: eddie@ehuk.net, Eddie Chapman <eddie@ehuk.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:32.0) Gecko/20100101 Thunderbird/32.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Francis Moreau <francis.moro@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>
CC: Peter Kieser <peter@kieser.ca>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
References: <20140805043346.GF541@moria.home.lan> <53E10D48.1010700@kernel.dk> <53E7251B.3080305@kieser.ca> <540966BA.9030106@gmail.com> <5409C5FC.6020406@kernel.dk>
In-Reply-To: <5409C5FC.6020406@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/14 15:17, Jens Axboe wrote:
> (from oldest to newest). And that's just from 3.16 to 3.17-rc3, going
> all the way back to 3.10 would be a lot of work. If there's anyone that
> cares about bcache on stable kernels (and actually use it), now would be
> a good time to pipe up.

Just "piping up" as I care about bcache and actually use it in 
production on 3.10! Shame I don't have the knowledge to try and backport 
these though :-)

Eddie

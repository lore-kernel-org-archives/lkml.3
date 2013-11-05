Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3KEWot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:44:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41263 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3KEWor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:44:47 -0500
Message-ID: <527974CA.6050102@kernel.dk>
Date: Tue, 05 Nov 2013 15:44:26 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Joe Thornber <ejt@redhat.com>
Subject: Re: linux-next: build failure after merge of the device-mapper tree
References: <20131105135128.496b8b2f599d11f2d30ad70c@canb.auug.org.au>	<20131105032054.GA19421@redhat.com>	<20131105143248.551f68c3cd9fe1902860c1ff@canb.auug.org.au>	<20131105125456.GA25219@redhat.com>	<52791B33.9060001@kernel.dk> <20131106094257.43d679d08de823ee5064ddff@canb.auug.org.au>
In-Reply-To: <20131106094257.43d679d08de823ee5064ddff@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 03:42 PM, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Tue, 05 Nov 2013 09:22:11 -0700 Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Just a heads up that I plan on sending the block bits shortly, hopefully
>> merging sooner rather than later. This round is huge, so I'd like to get
>> it in asap.
> 
> Given the problems we have seen since the inclusion into linux-next of
> some of it, don't you think it could do with a little more bedding in?

It'll either simmer without problems for the next day or two, or the
immutable bits will get pushed to the next merge window.

-- 
Jens Axboe


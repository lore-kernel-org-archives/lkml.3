Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaA1UeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:34:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25834 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaA1UeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:34:19 -0500
Message-ID: <52E81474.8020304@oracle.com>
Date: Tue, 28 Jan 2014 15:35:00 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Roger Pau Monne <roger.pau@citrix.com>, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] xen-blkback: bug fixes
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com> <20140128193837.GA32072@andromeda.dapyr.net>
In-Reply-To: <20140128193837.GA32072@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 02:38 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 28, 2014 at 06:43:32PM +0100, Roger Pau Monne wrote:
>> blkback bug fixes for memory leaks (patches 1 and 2) and a race
>> (patch 3).
> They all look OK to me. I've stuck them in my 'stable/for-jens-3.14'
> branch and are testing them now (hadn't pushed it yet).
>
> Matt and Matt,
>
> Could you take a look at the other two patches as well?
>
> David, Boris,
>
> Are you OK with pushing those patches out to Jens Axboe if nobody
> gives an NACK by Friday?

The patches look reasonable to me so I don't have any objections (but
I am not particularly familiar with this code.)

-boris

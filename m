Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaFHMFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:05:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbaFHMFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:05:49 -0400
Message-ID: <53945193.10903@redhat.com>
Date: Sun, 08 Jun 2014 14:05:39 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
Subject: Re: [PATCH 7/7] lib/random32.c: Remove redundant U suffixes on integers
References: <20140608111425.3897.qmail@ns.horizon.com>
In-Reply-To: <20140608111425.3897.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 01:14 PM, George Spelvin wrote:
>> [ Please also Cc Hannes in your series. ]
>
> Thank you!  But there are two frequent kernel contributors with that name;
> the other is Hannes Reinecke <hare@suse.de>.

I mean <hannes@stressinduktion.org> which I already did for you. I
thought this would have been obvious based on:

    git log lib/random32.c

;)

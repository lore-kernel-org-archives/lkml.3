Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935351AbaDJK0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:26:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933885AbaDJK0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:26:39 -0400
Message-ID: <534671DB.50802@redhat.com>
Date: Thu, 10 Apr 2014 11:26:35 +0100
From: Jeremy Harris <jgh@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
CC: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
References: <1396910068-11637-1-git-send-email-mgorman@suse.de> <5343A494.9070707@suse.cz> <alpine.DEB.2.10.1404080914280.8782@nuc> <CA+TgmoY=vUdtdnJUEK1h-UcaNoqqLUctt44S8vj2B7EVUXUOyA@mail.gmail.com> <alpine.DEB.2.10.1404081752390.16708@nuc>
In-Reply-To: <alpine.DEB.2.10.1404081752390.16708@nuc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/14 23:58, Christoph Lameter wrote:
> The reason that zone reclaim is on by default is that off node accesses
> are a big performance hit on large scale NUMA systems (like ScaleMP and
> SGI). Zone reclaim was written *because* those system experienced severe
> performance degradation.
>
> On the tightly coupled 4 and 8 node systems there does not seem to
> be a benefit from what I hear.

In principle, is this difference in distance something the kernel
could measure?
-- 
Cheers,
    Jeremy



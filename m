Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaG3JmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:42:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:29059 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbaG3JmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:42:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,763,1400050800"; 
   d="scan'208";a="569350589"
Message-ID: <53D8BD5E.2090601@intel.com>
Date: Wed, 30 Jul 2014 17:39:42 +0800
From: Jike Song <jike.song@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dario Faggioli <dario.faggioli@citrix.com>
CC: "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, intel-gfx@lists.freedesktop.org,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [Xen-devel] [Intel-gfx] [Announcement] Updates to XenGT - a Mediated
 Graphics Passthrough Solution from Intel
References: <53D215D3.50608@intel.com> <1406628570.4038.37.camel@Solace>
In-Reply-To: <1406628570.4038.37.camel@Solace>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 06:09 PM, Dario Faggioli wrote:
> Perhaps the info is available somewhere already (in which case, sorry),
> but what's the (if any) upstreaming plan/status/ETA?
>
> I think this info could well be part of these updates. :-)

Thanks for your opinion :-)

We plan to start the upstreaming work in this quarter. For your information,
Wei's IOREQ server enhancement(aka "Extend ioreq-server to support page write protection")
is actually part of the upstreaming effort.

Patches for different components will be sent out later.

>
> Thanks and Regards,
> Dario
>

--
Thanks,
Jike

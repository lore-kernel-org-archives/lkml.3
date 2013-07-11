Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3GKXTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:19:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:59414 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3GKXTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:19:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,648,1367996400"; 
   d="scan'208";a="368764608"
Message-ID: <51DF3F09.1010808@linux.intel.com>
Date: Thu, 11 Jul 2013 16:26:01 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rui.zhang@intel.com
Subject: Re: Thermal: CPU Package temperature thermal
References: <20130711211543.0E83166098F@gitolite.kernel.org> <20130711230829.GA19062@redhat.com>
In-Reply-To: <20130711230829.GA19062@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 04:08 PM, Dave Jones wrote:
>   > +static int sys_get_curr_temp(struct thermal_zone_device *tzd, unsigned long *temp)
>   > +static int sys_get_trip_temp(struct thermal_zone_device *tzd,
>   > +int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
>   > +static int sys_get_trip_type(struct thermal_zone_device *thermal,
>   
> I saw these and thought "huh, syscalls in a module?"
>
> Perhaps a better prefix can be used here for these function names ?
>
> 	Dave
>
>
Certainly. Here "sys" stands for "sys-fs".

Thanks,
Srinivas

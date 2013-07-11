Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3GKXIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:08:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3GKXIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:08:43 -0400
Date: Thu, 11 Jul 2013 19:08:29 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: rui.zhang@intel.com, srinivas.pandruvada@linux.intel.com
Subject: Re: Thermal: CPU Package temperature thermal
Message-ID: <20130711230829.GA19062@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	rui.zhang@intel.com, srinivas.pandruvada@linux.intel.com
References: <20130711211543.0E83166098F@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711211543.0E83166098F@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +static int sys_get_curr_temp(struct thermal_zone_device *tzd, unsigned long *temp)
 > +static int sys_get_trip_temp(struct thermal_zone_device *tzd,
 > +int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
 > +static int sys_get_trip_type(struct thermal_zone_device *thermal,
 
I saw these and thought "huh, syscalls in a module?"

Perhaps a better prefix can be used here for these function names ?

	Dave


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3HCAKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:10:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49344 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753950Ab3HCAKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:10:45 -0400
Message-ID: <1375488644.2034.150.camel@joe-AO722>
Subject: Re: [RFC v01 1/3] PowerCap: Documentation
From: Joe Perches <joe@perches.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Fri, 02 Aug 2013 17:10:44 -0700
In-Reply-To: <1375466932-11842-2-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <1375466932-11842-2-git-send-email-srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 11:08 -0700, Srinivas Pandruvada wrote:
> Added power cap framework documentation. This explains the use of power capping framework,
> sys-fs and programming interface.

[]

> +Power Zone Attributes
> +=================================
> +Monitoring attributes
> +----------------------
> +	
> +energy_uj (rw): Current energy counter in micro-joules. Write to energy counter
> +resets the counter to zero. If the counter can not be reset, then this attribute
> +is read-only.
> +
> +max_energy_range_uj (ro): Range of the above energy counter in micro-joules.
> +
> +power_uw (rw): Current power counter in micro-watts. Write to this counter
> +resets the counter to zero. If the counter can not be reset, then this attribute
> +is read-only.
> +max_power_range_uw (ro): Range of the above energy counter in micro-watts.
> +
> +It is possible that some domains can have both power and energy counters and
> +ranges, but at least one is mandatory.

Given that the ranges seem to be u64s, perhaps the
lower bounds are too high.  Why not nano/pico/fempto
watts/joules/seconds?



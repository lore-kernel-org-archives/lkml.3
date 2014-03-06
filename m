Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaCFQbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:31:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:13204 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbaCFQbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:31:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,601,1389772800"; 
   d="scan'208";a="493567653"
Message-ID: <5318A2BE.2070707@linux.intel.com>
Date: Thu, 06 Mar 2014 08:30:54 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, mingo@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "alan@linux.intel.com" <alan@linux.intel.com>
Subject: Re: [PATCH] x86: new Intel Atom SoC power management controller driver
References: <5317EC0C.4010807@linux.intel.com> <5317F044.8080407@linux.intel.com> <531805D4.6040806@linux.intel.com> <5318076C.7080605@linux.intel.com> <531808BD.4070000@linux.intel.com> <53180D39.7050207@linux.intel.com> <53180E98.9000608@linux.intel.com>
In-Reply-To: <53180E98.9000608@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 09:58 PM, Li, Aubrey wrote:
>>
>> What we absolutely don't want to happen is someone starting to use these
>> unstable interfaces for something other than debugging.  If debugfs ever
>> needs to be mounted in a system for full functionality, that is a bug.
> 
> Understood. But we don't have a plan to use it now. Just for observation
> and diagnosis purpose only.
> 
> Are you suggesting we should put them into sysfs now?
> 

No, I'm just trying to understand if there is a risk.

	-hpa



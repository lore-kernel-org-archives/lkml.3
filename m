Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab3DDApN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:45:13 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:48242 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3DDApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:45:08 -0400
X-Greylist: delayed 2532 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2013 20:45:08 EDT
Message-ID: <515CC317.2000703@elopez.com.ar>
Date: Wed, 03 Apr 2013 21:02:31 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH V2 4/7] kbuild: always run gcc -E on *.dts, remove cmd_dtc_cpp
References: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org> <1365032098-22825-4-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1365032098-22825-4-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

El 03/04/13 20:34, Stephen Warren escribió:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Replace cmd_dtc with cmd_dtc_cpp, and delete the latter.
> 
> Previously, a special file extension (.dtsp) was required to trigger
> the C pre-processor to run on device tree files. This was ugly. Now that
> previous changes have enhanced cmd_dtc_cpp to collect dependency
> information from both gcc -E and dtc, we can transparently run the pre-
> processor on all device tree files, irrespective of whether they
> 

I think a line got dropped on the commit description by mistake.

Regards,

Emilio

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3JHQ1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:27:11 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:46136 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab3JHQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:27:08 -0400
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah1JALAxVFJV5qhFPGdsb2JhbABZgweDbIUAuUKBIBcDAQEBATg1giUBAQQBOhwjEAgDDhMlDwUlChqIEwq6WxaPLAeDH4EEA5gAhkqOXTo
X-IronPort-AV: E=Sophos;i="4.90,1057,1371074400"; 
   d="scan'208";a="410566237"
Date: Tue, 8 Oct 2013 18:29:17 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Murphy <bugzilla@colorremedies.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20131008162917.GA7773@polaris.bitmath.org>
References: <524A4384.4040403@roeck-us.net>
 <20131002035156.GA566@roeck-us.net>
 <20131002095339.GA2716@polaris.bitmath.org>
 <524C1FE1.4050207@roeck-us.net>
 <20131002163418.GA4557@polaris.bitmath.org>
 <20131002164718.GA7392@roeck-us.net>
 <20131002172410.GA381@polaris.bitmath.org>
 <525346D3.30500@roeck-us.net>
 <6918F624-B267-4DB5-95A2-7E09448CA3E4@colorremedies.com>
 <20131008154809.GB18402@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008154809.GB18402@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> > > So, what should we do with this patch ? Apply it ?
> > 
> > So far I'm getting nothing on the original machine. As of today it's applied as the last patch on 3.12.0-0.rc4.git0.1.fc20.x86_64. Unfortunately at the moment I'm a bit too dense to figure out how to get a new kernel applied to an existing live package so I can try this on a USB stick. While maybe unrelated, the oops was occurring at least 4x as often booted from USB stick media than HDD.
> > 
> 
> Seems to me we should apply it.
> 
> Henrik,
> 
> what do you think ? Did you have time for additional testing ?
> If you think we should apply it, please send me a signed patch.

I want to make one more test tomorrow, then I'll send a proper patch. Thanks!

Henrik

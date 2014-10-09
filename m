Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaJIUrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:47:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:47103 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaJIUrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:47:40 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Tim Bird <tbird20d@gmail.com>, Tim Bird <tim.bird@sonymobile.com>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "linux-arm-msm\@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: dts: Add initial DTS file for Sony Xperia Z1 phone
References: <542B338D.2040909@sonymobile.com>
	<CA+bK7J5x60WyyAp6+hGDf-fyAC=skQu9EdPUabPrzhMCDnOCrA@mail.gmail.com>
	<6FB01741-5960-45CE-9AB8-20CBE5D9D212@codeaurora.org>
Date: Thu, 09 Oct 2014 13:47:37 -0700
In-Reply-To: <6FB01741-5960-45CE-9AB8-20CBE5D9D212@codeaurora.org> (Kumar
	Gala's message of "Thu, 9 Oct 2014 13:22:37 -0500")
Message-ID: <7h4mvdnf6e.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

Kumar Gala <galak@codeaurora.org> writes:

> Will not make the 3.18 merge window.  I will queue it up for 3.19.

Yes, it's too late for the merge window proper, but since it's DT only
support for new platform, you can submit it as a fix to us (arm-soc) for
v3.18-rc.

In fact, if you chose (and if it's known to work for v3.17 and/or
earlier), you can even mark it for stable.  Greg has said he's OK with
DT-only changes like this that only affect a specific platform to go
into stable.

Kevin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaLDJFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:05:36 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:41748 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785AbaLDJFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:05:33 -0500
Message-ID: <548023BD.8020804@arm.com>
Date: Thu, 04 Dec 2014 09:05:01 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH 1/5] ASoC: dwc: Allocate resources with devm_ioremap_resource
References: <547F3C96.9070509@arm.com> <20141203182659.GG7712@sirena.org.uk>
In-Reply-To: <20141203182659.GG7712@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 18:26, Mark Brown wrote:
> On Wed, Dec 03, 2014 at 04:38:46PM +0000, Andrew Jackson wrote:
>> Prepare for the introduction of device-tree support by re-ordering some
>> of the allocations and using devm_iomap_resource to simplify IO mapping.
> 
> Applied, thanks.
> 

Lars-Peter Clausen had some comments on this patch so I was intending to resubmit it.  Would you prefer that I submit a patch to my original?

  Andrew

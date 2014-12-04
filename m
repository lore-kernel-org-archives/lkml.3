Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaLDI6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:58:31 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:43243 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753055AbaLDI6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:58:30 -0500
Message-ID: <54802216.8030908@arm.com>
Date: Thu, 04 Dec 2014 08:57:58 +0000
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
Subject: Re: [PATCH 0/5] ASoC: dwc: Add device tree support to designware
 I2S
References: <547F3C8C.5000607@arm.com> <20141203172111.GB7712@sirena.org.uk>
In-Reply-To: <20141203172111.GB7712@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 17:21, Mark Brown wrote:
> On Wed, Dec 03, 2014 at 04:38:36PM +0000, Andrew Jackson wrote:
>> This patch set extends the DesignWare I2S driver to provide device
>> tree support and fixes a couple of small faults.
> 
> If you're sending fixes the fixes should be the first things in the
> series - the idea is that we should be able to send the fixes to Linus
> and stable separate to any new features.
> 

Oh, sorry about that, I will reorder the patches before resubmission.

   Andrew


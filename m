Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaAEQBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 11:01:11 -0500
Received: from smtp-out-019.synserver.de ([212.40.185.19]:1056 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751112AbaAEQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 11:01:10 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24364
Message-ID: <52C981D2.2020800@metafoo.de>
Date: Sun, 05 Jan 2014 17:01:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Florian Meier <florian.meier@koalo.de>
CC: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [RFC] ASoC: Adding trivial codec drivers
References: <52C95977.5070400@koalo.de>
In-Reply-To: <52C95977.5070400@koalo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2014 02:09 PM, Florian Meier wrote:
> This is not intended to be a real patch.
> I would just like to ask if this is the preferred way 
> to add codec and machine driver for codecs without
> I2C or SPI configuration possibilities or should I 
> rather use a more generic approach?
> 

Should be fine. There are a couple of other similar drivers.

- Lars


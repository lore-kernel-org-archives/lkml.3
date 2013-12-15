Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3LOTAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 14:00:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab3LOTAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 14:00:43 -0500
Message-ID: <52ADFC44.7040003@redhat.com>
Date: Sun, 15 Dec 2013 20:00:20 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oliver Schinagl <oliver@schinagl.nl>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>, grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        Richard Zhu <r65037@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl> <1386159055-10264-3-git-send-email-oliver@schinagl.nl> <20131204123708.GD3158@htj.dyndns.org> <529F2677.3070208@schinagl.nl> <20131204131402.GG3158@htj.dyndns.org> <529F2B41.8090009@schinagl.nl> <20131204132312.GH3158@htj.dyndns.org> <20131206100117.59609a8a@skate> <52A19502.1090409@schinagl.nl>
In-Reply-To: <52A19502.1090409@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I think it would be a good idea to merge ahci upstream using the
ahci_imx.c method for now. You already indicated that you were not against
doing that for now.

Oliver is working on getting a cleaner solution for this, but doing this
properly takes tinme, and we would like to move forward with getting
sunxi ahci support upstream in the mean time.

So if it is ok with you we would like to move forward with the version
initially posted. Therefor I would like to request you to review it
(glossing over the platform device instantiating a platform device
approach for now), and provide us with feedback so that we can do a v2
and start moving this towards the mainline kernel.

Regards,

Hans

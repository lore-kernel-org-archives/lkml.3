Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650Ab3BIDri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 22:47:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35840 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab3BIDrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 22:47:37 -0500
Message-ID: <5115C6D8.5040404@wwwdotorg.org>
Date: Fri, 08 Feb 2013 20:47:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/4] clocksource: bcm2835: use the device_node pointer
 passed to init
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com> <1360264144-20714-3-git-send-email-robherring2@gmail.com>
In-Reply-To: <1360264144-20714-3-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 12:09 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> We've already matched the node, so use the node pointer passed in.

Patches 1 & 2,

Tested-by: Stephen Warren <swarren@wwwdotorg.org>

(i.e. with my bcm2835 hat on:-)


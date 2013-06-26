Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3FZEYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:24:04 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:43465 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3FZEX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:23:58 -0400
Message-ID: <51CA6CCE.9060202@synopsys.com>
Date: Wed, 26 Jun 2013 09:53:42 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH V3] irqchip: Add TB10x interrupt controller driver
References: <20130530211944.05F4D3E0A90@localhost> <1370014348-21121-1-git-send-email-christian.ruppert@abilis.com> <alpine.DEB.2.02.1306251551020.4013@ionos.tec.linutronix.de> <20130625141141.GA1720@ab42.lan>
In-Reply-To: <20130625141141.GA1720@ab42.lan>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 07:41 PM, Christian Ruppert wrote:
>>> > > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
>>> > > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
>> > 
>> > Why is Pierrick in the SOB chain? 
> We work on the platform port together and review and test each others'
> patches. It is planned submitting several of his patches as soon as
> basic platform is in.

Which is fine, however the rule is, person sending the patch needs to do the last SOB.



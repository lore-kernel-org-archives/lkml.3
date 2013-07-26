Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab3GZSia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:38:30 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:57729 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3GZSi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:38:27 -0400
Message-ID: <51F2C220.5040407@gmail.com>
Date: Fri, 26 Jul 2013 13:38:24 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
Subject: Re: [PATCH 4/5] sata, highbank: set tx_atten override bits
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com> <1374851518-4802-4-git-send-email-mark.langsdorf@calxeda.com> <20130726162231.GD3528@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130726162231.GD3528@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 11:22 AM, Mark Rutland wrote:
> On Fri, Jul 26, 2013 at 04:11:57PM +0100, Mark Langsdorf wrote:
>> Some board designs do not drive the SATA transmit lines within the
>> specification. The ECME can provide override settings, on a per board
>> basis, to bring the transmit lines within spec. Read those settings
>> from the DTB and program them in.
> 
> How variable is the use of this property going to be? Would it instead
> be possible to decide that this was necessary, and choose the
> appropriate values based on a compatible property?

It is based on compliance testing of the particular board design. Basing
on a compatible property would not work in this case.

Rob


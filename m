Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaIAMLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:11:53 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:7663 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIAMLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:11:51 -0400
Message-ID: <54046284.5000707@imgtec.com>
Date: Mon, 1 Sep 2014 13:11:48 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Andrew Bresticker <abrestic@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Jeffrey Deans" <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] of: Add binding document for MIPS GIC
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <1409350479-19108-4-git-send-email-abrestic@chromium.org> <20140901110119.GB6617@leverpostej>
In-Reply-To: <20140901110119.GB6617@leverpostej>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/14 12:01, Mark Rutland wrote:
> On Fri, Aug 29, 2014 at 11:14:30PM +0100, Andrew Bresticker wrote:
>> +Required properties:
>> +- compatible : Should be "mti,global-interrupt-controller"
> 
> I couldn't find "mti" in vendor-prefixes.txt (as of v3.17-rc3). If
> there's not a patch to add it elsewhere, would you mind providing one
> with this series?

It should be noted that there does already exist an "img" prefix in that
file which may be more suitable (mti stands for MIPS Technologies Inc.).

Though of course it appears the mti prefix is already in use, like
"mti,cpu-interrupt-controller" in the binding example.

Cheers
James

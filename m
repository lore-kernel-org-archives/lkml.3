Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbaH3Gdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 02:33:47 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:57125 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaH3Gdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 02:33:46 -0400
Message-ID: <5401703B.4090801@openwrt.org>
Date: Sat, 30 Aug 2014 08:33:31 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
CC: Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] MIPS: GIC device-tree support
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 30/08/2014 00:14, Andrew Bresticker wrote:
> Based on 3.17-rc2 and boot tested on Danube (+ out of tree patches) and
> Malta.

Lantiq makes a mips soc called danube. is this the same family or is
this just a name collision between 2 chip vendors ?

	John

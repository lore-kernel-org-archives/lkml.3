Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3JBTD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:03:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37206 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab3JBTDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:03:54 -0400
Message-ID: <524C6D64.8080801@zytor.com>
Date: Wed, 02 Oct 2013 12:00:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
References: <cover.1380727889.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1380727889.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 08:35 AM, Michal Simek wrote:
> 
> Based on my discussion at ELC with Greg KH the new driver should
> support firmware interface for loading bitstream.
> 

As I have previously stated, I think this is a mistake simply because
the firmware interface is a bad mapping on requirements for an FPGA,
especially once you account for the vast number of ways an FPGA can
get loaded and you take partial reconfiguration into account.  I
happen to be at a face to face meeting with Greg today, so I'll pick
his brain a bit.

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab3GaQ35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:29:57 -0400
Received: from up.free-electrons.com ([94.23.35.102]:48670 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752816Ab3GaQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:29:55 -0400
Date: Wed, 31 Jul 2013 18:29:19 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] Defining schemas for Device Tree
Message-ID: <20130731182919.1168b88e@skate>
In-Reply-To: <2300415.ZNNddtVGav@thinkpad>
References: <1706112.Xn49tiCSKF@thinkpad>
	<20130731113401.GM9858@sirena.org.uk>
	<CAKON4OyQUcqw1RFcWj3uy0i2i+3UBB8fG1rPw6tcrMGDZ40y6g@mail.gmail.com>
	<2300415.ZNNddtVGav@thinkpad>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Tomasz Figa,

On Wed, 31 Jul 2013 14:21:49 +0200, Tomasz Figa wrote:

> u-boot still does not have generic driver model or at least did not have when 
> I last checked it not so long ago, so it seems like there is still long way to 
> go for using FDT as source of information about hardware in u-boot.
> 
> barebox [1], aka u-boot-v2, might be closer to this approach (it might be 
> already using it, but this needs to be checked) as it already has generic 
> driver model and support for DT.

There are already some platforms in Barebox that are using the Device
Tree. For example, the basic Marvell platforms support in Barebox now
uses the Device Tree.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

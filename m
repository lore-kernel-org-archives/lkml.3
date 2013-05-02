Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598Ab3EBTEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:04:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761292Ab3EBTEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:04:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v10 0/2] (arm-soc for v3.10) arm: introduce psci_smp_ops
Date: Thu, 2 May 2013 21:03:58 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>
References: <alpine.DEB.2.02.1304301707290.5398@kaball.uk.xensource.com> <alpine.DEB.2.02.1305021938170.5398@kaball.uk.xensource.com> <20130502184801.GF14496@n2100.arm.linux.org.uk>
In-Reply-To: <20130502184801.GF14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305022103.58445.arnd@arndb.de>
X-Provags-ID: V02:K0:IawLkRaxDBpYzky4Vf0FrpkhPFKgIsQKFGXpKlvUY7f
 E1MdvsOvUd8w9uh8JxLgXYLS5TY2zFYbqcbqT++imK9oDPlxEA
 ahkoHGaa3uaxhul0NW5bOMNW5FBlNNWkxAUG7/1blK8hMc5MWf
 sHe53WpG6cfh1j6qFKGlT3cs06/hUJC9KBDjsRkL1gqtfkpe4R
 mbmVexAbl/GQ5/3eIGn2tuv/EDD5Wkx94G7DHi1xagUfz69pVq
 9Oip/CvpvhqHWh4xkJJ4RM4T1NIMd6HJJXsO4LT8Q26AVLMVTD
 kbd7NTLY9xG2p7JMVfAY7Bxks3/cF6GYhR9kKTEZ7nlHgtXT6Y
 dAk1+HNx3Fy22hhuJGWU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Russell King - ARM Linux wrote:
> The only issue that there is is where we are in the development cycle
> (almost mid merge window), and I've yet to push anything to Linus thanks
> to late discovery of various messups in other chunks of code submitted
> via my tree - I'm starting to drop stuff from my tree in the hope that
> I'll get back to something that's going to be suitable for mainline.
> 
> I really don't want to go pulling anything else at the moment in the
> hope of getting what I currently have out the door.
> 
> And in any case, we shouldn't be adding any new code to our trees at
> this point in time.

Agreed. I would have like to see the patches in 3.10, but the timing
didn't work out.

Stefano, I'm sure we can queue it up early for 3.11 if you send them
again after the merge window. Sorry you had to go through 10 versions
and not getting it merged in time in the end.

	Arnd

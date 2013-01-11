Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3AKLd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:33:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKLd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:33:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 4/4] serial/arc-uart: switch to devicetree based probing
Date: Fri, 11 Jan 2013 11:33:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com> <1357885223-19243-5-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1357885223-19243-5-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301111133.43507.arnd@arndb.de>
X-Provags-ID: V02:K0:Eudm1CSpGFD0fdC0+v3N6RaLEy6l6dZNb6wsNXI+vS7
 XWJdyEto0h7ET5RzjRXjw/CploETYv6frUniEfg6lY0O3CuZwd
 FfSFvZ2RvEeM+/4GFJvqcmCUB0dLvb4iB25VhNf6HNQ4phKSBY
 KhYy800NUPmqH3b51KXv9EbslSENPQ69iNJbhAQ2ZZsO+eEGuD
 9PxZbbuq5d80BfZVOQiofdKn/kBeWaPxf6Ud9ofSaytHvkPaQ+
 qhdPrSZV4Tu+rh6sBJwmBw3p+vm4esmv+HUB+d8wU+bBYuRjIg
 Diiop3ZYGEWV0zOSQxI2TB7+ioMYNyVsrPSuJ7XnkOOtG/OBnu
 RE9zNJh8e+u+nrK/YEl4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2013, Vineet Gupta wrote:
> * DT binding for arc-uart
> * With alll the bits in place we can now use DT probing.
> 
> Note that there's a bit of kludge right now because earlyprintk portion
> of driver can't use the DT infrastrcuture to get resoures/plat_data.
> This requires some infrastructre changes to of_flat_ framework
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-serial@vger.kernel.org
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: linux-serial@vger.kernel.org

Acked-by: Arnd Bergmann <arnd@arndb.de>

Quick question about the name though: is this UART only used
on ARC, or is it something that synopsys licenses to other
parties as well? If the latter is true, we might want to 
add a more generic "compatible" value for those that use
it on another architecture.

	Arnd

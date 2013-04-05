Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162604Ab3DEVK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:10:57 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41062 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162482Ab3DEVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:10:56 -0400
Message-ID: <515F3DD8.2040108@free-electrons.com>
Date: Fri, 05 Apr 2013 23:10:48 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2 0/9] rm: mvebu: Enable LPAE support for Armada XP SoCs
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com> <201304052246.12731.arnd@arndb.de>
In-Reply-To: <201304052246.12731.arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 10:46 PM, Arnd Bergmann wrote:
> On Friday 05 April 2013, Gregory CLEMENT wrote:
>> The Armada XP SoCs have LPAE support. This is the second version patch
>> set whixh allow to run kernel on this SoCs with LPAE support.
>>
>> The biggest changes are the conversion of the device tree file to 64
>> bits in order to be able to use more than 4GB of memory (without this
>> the LPAE is pointless).
>>
> 
> The series looks good overall, I've commented on trivial details.

So there is still hope to have this patch set in 3.10 :)

> 
> Also, please use "ARM: mvebu: ..." in the subject rather than the lower-case
> version.

OK I will, but I saw a lot of 'arm' written in lower-case int the subject of emails
on the LAKML.
> 
> 	Arnd
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

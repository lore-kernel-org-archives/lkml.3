Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaIFCTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 22:19:05 -0400
Received: from kepler.killerwolves.net ([103.4.235.74]:51886 "EHLO
	kepler.killerwolves.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIFCTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 22:19:02 -0400
X-Spam-Check-By: kepler
Message-ID: <540A6F09.9000605@killerwolves.net>
Date: Sat, 06 Sep 2014 12:18:49 +1000
From: Ben Peddell <klightspeed@killerwolves.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Arnaud Ebalard <arno@natisbad.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] ARM: MVEBU: Netgear RN102: Use Hardware BCH ECC
References: <1409898233-9273-1-git-send-email-klightspeed@killerwolves.net>	<20140905154140.GA1377@arch.hh.imgtec.org> <87ha0l23nt.fsf@natisbad.org>
In-Reply-To: <87ha0l23nt.fsf@natisbad.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06 Sep 2014 at 06:49, Arnaud Ebalard wrote:
> FWIW, you can add my:
> 
>  Tested-by: Arnaud Ebalard <arno@natisbad.org>
>  
> Additionally, Ezequiel, would anything prevent pushing the patch to
> stable team (nand entry in .dts was added in 3.14):
> 
>  Fixes: 92beaccd8b49 ("ARM: mvebu: Enable NAND controller in ReadyNAS 102 .dts file")

Depends-on: 5b3e507820c6 ("mtd: nand: pxa3xx: Use ECC strength and step size devicetree binding")

The devicetree binding is not currently in linux-stable/linux-3.14.y

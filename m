Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaBJJAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:00:48 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:61234 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaBJJAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:00:45 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2014 04:00:44 EST
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9gNPnzI0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] net: rfkill-regulator: Add devicetree support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1392020862.4128.1.camel@jlt4.sipsolutions.net>
Date: Mon, 10 Feb 2014 09:54:34 +0100
Cc: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, grant.likely@linaro.org,
        NeilBrown Brown <neilb@suse.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <BF9457FD-CEED-4290-9150-57F51F6E42FC@goldelico.com>
References: <1391802529-29861-1-git-send-email-marek@goldelico.com> (sfid-20140207_204900_539631_47DCB6B7) <1392020862.4128.1.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.02.2014 um 09:27 schrieb Johannes Berg:

> On Fri, 2014-02-07 at 20:48 +0100, Marek Belisko wrote:
> 
>> +#define RFKILL_TYPE_ALL		(0)
>> +#define RFKILL_TYPE_WLAN	(1)
>> +#define RFKILL_TYPE_BLUETOOTH	(2)
>> +#define RFKILL_TYPE_UWB		(3)
>> +#define RFKILL_TYPE_WIMAX	(4)
>> +#define RFKILL_TYPE_WWAN	(5)
>> +#define RFKILL_TYPE_GPS		(6)
>> +#define RFKILL_TYPE_FM		(7)
>> +#define RFKILL_TYPE_NFC		(8)
> 
> This seems like a bad idea since there's an enum elsewhere in userspace
> API already.

Yes,
you are right. It is defined in include/uapi/linux/rfkill.h

Tnx,
Nikolaus


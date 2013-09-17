Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3IQWFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:05:45 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4443 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3IQWFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:05:44 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5238D206.9030701@broadcom.com>
Date: Tue, 17 Sep 2013 15:04:54 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
cc: "Olof Johansson" <olof@lixom.net>, "Stephen Warren" <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, "Chris Ball" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, bcm@fixthebug.org
Subject: Re: [PATCH] ARM: bcm: Add DEBUG_LL console support
References: <1379455187-5812-1-git-send-email-csd@broadcom.com>
 <20130917220323.GS12758@n2100.arm.linux.org.uk>
In-Reply-To: <20130917220323.GS12758@n2100.arm.linux.org.uk>
X-WSS-ID: 7E260EC90UO8262147-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-09-17 03:03 PM, Russell King - ARM Linux wrote:
> On Tue, Sep 17, 2013 at 02:59:47PM -0700, Christian Daudt wrote:
>> This patch adds low level debug uart support to Broadcom
>>   mobile based SOCs.
>>
>> Signed-off-by: Christian Daudt <csd@broadcom.com>
>> Reviewed-by: James King <jamesk@broadcom.com>
> Unfortunately, your patch is out of date.
>
> Please have a look at v3.12-rc1's debugging infrastructure.  You should
> not need to add any .S file(s) for 8250 based ports, and in fact,
> 8250_32.S is gone.  It's now all done through Kconfig for these ports.
>
> Thanks.
>
Oops. Ok, I last rebased it against -11-rc4. I'll rework it for 12-rc1 then.

  Thanks,
    csd



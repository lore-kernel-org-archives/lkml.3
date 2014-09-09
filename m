Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaIILoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:44:16 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:53435 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaIILoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:44:14 -0400
Message-ID: <540EE809.9020901@mojatatu.com>
Date: Tue, 09 Sep 2014 07:44:09 -0400
From: Jamal Hadi Salim <jhs@mojatatu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org, sandeep_n@ti.com,
        Benjamin LaHaise <bcrl@kvack.org>,
        shrijeet Mukherjee <shm@cumulusnetworks.com>
Subject: Re: [PATCH v2 0/3] net: Add Keystone NetCP ethernet driver support
References: <1408115562-22487-1-git-send-email-santosh.shilimkar@ti.com> <20140821.163612.282672926741753926.davem@davemloft.net> <53F79DC5.8030003@ti.com> <540DC00F.1080103@ti.com>
In-Reply-To: <540DC00F.1080103@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/14 10:41, Santosh Shilimkar wrote:

>> The NetCP plugin module infrastructure use all the standard kernel
>> infrastructure and its very tiny.

So i found this manual here:
http://www.silica.com/fileadmin/02_Products/Productdetails/Texas_Instruments/SILICA_TI_66AK2E05-ds.pdf

Glad there is an open document!
There are a couple of ethernet switch chips I can spot there.

Can i control those with "bridge" or say "brctl" utilities?

I can see the bridge ports are exposed and i should be able to
control them via ifconfig or ip link. Thats what "standard
kernel infrastructure" means. Magic hidden in a driver is
not.

Take a look at recent netconf discussion (as well as earlier
referenced discussions):
http://vger.kernel.org/netconf-nf-offload.pdf

Maybe we can help providing you some direction?
The problem is it doesnt seem that the offload specs for
those other pieces are open? e.g how do i add an entry
to the L2 switch?

cheers,
jamal

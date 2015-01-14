Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbbANOZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:25:08 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58361 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbbANOZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:25:06 -0500
Message-ID: <54B67C41.3080400@gmail.com>
Date: Wed, 14 Jan 2015 15:25:05 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        David Miller <davem@davemloft.net>
CC: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] atm: remove deprecated use of pci api
References: <20150112161042.GA11374@sloth>	<20150113.215944.1703977685948196746.davem@davemloft.net> <20150114085851.234db50d@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20150114085851.234db50d@thirdoffive.cmf.nrl.navy.mil>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14/01/2015 14:58, chas williams - CONTRACTOR wrote:
> I think I would like to go through and just fix all the usages of the
> older pci interface.  This patch isn't very complete due to its
> automated nature.
>
> I will make some time this weekend.
It was my original intent to produce a complete patch, I obviously
misused the tool and forgot a significant number of cases.

But I am ok with fixing that and submitting a complete version of this
patch if you like.



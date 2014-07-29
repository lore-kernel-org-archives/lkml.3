Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaG2C7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:59:55 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:54843 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaG2C7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:59:50 -0400
MIME-Version: 1.0
In-Reply-To: <309B89C4C689E141A5FF6A0C5FB2118B73366373@ORSMSX104.amr.corp.intel.com>
References: <1406533278-27979-1-git-send-email-ethan.zhao@oracle.com>
	<309B89C4C689E141A5FF6A0C5FB2118B73366373@ORSMSX104.amr.corp.intel.com>
Date: Tue, 29 Jul 2014 10:59:49 +0800
Message-ID: <CABawtvMWmi4c-9C_EWZpOusjLHYNv0fwDW4uHoQZ9G0sS9NH8w@mail.gmail.com>
Subject: Re: [PATCH] ixgbe: remove useless bd_number from adapter struct
From: Ethan Zhao <ethan.kernel@gmail.com>
To: "Brown, Aaron F" <aaron.f.brown@intel.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Williams, Mitch A" <mitch.a.williams@intel.com>,
        Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Brown, Aaron F

On Tue, Jul 29, 2014 at 10:51 AM, Brown, Aaron F
<aaron.f.brown@intel.com> wrote:
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Ethan Zhao
>> Sent: Monday, July 28, 2014 12:41 AM
>> To: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
>> Carolyn; Skidmore, Donald C; Rose, Gregory V; Duyck, Alexander H; Ronciak,
>> John; Williams, Mitch A
>> Cc: Linux NICS; e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org;
>> linux-kernel@vger.kernel.org; ethan.kernel@gmail.com; Ethan Zhao
>> Subject: [PATCH] ixgbe: remove useless bd_number from adapter struct
>>
>> Because bd_number is not useful anymore, so remove it from adapter struct,
>> or
>> if keep it, we have to fix the boards driven counter bug in ixgbe_remove()
>> and
>> ixgbe_probe() only for trival debug purpose -- other output is enough.
>
> Thanks Ethan, I (briefly covering for Jeff Kirsher) have added this patch and your other one ofr ixgbevf to Jeff's internal tree.

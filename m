Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab3BGRbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:31:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759098Ab3BGRbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:31:12 -0500
Message-ID: <5113E4D9.2040408@redhat.com>
Date: Thu, 07 Feb 2013 18:31:05 +0100
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: NickCheng <nick.cheng@areca.com.tw>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@kernel.org,
        =?Big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Subject: Re: [PATCH 2/5]  arcmsr: Support Hibernation
References: <C9CA5F0351AD4BD282E0579486DA7AB8@arecaaebe11fae>
In-Reply-To: <C9CA5F0351AD4BD282E0579486DA7AB8@arecaaebe11fae>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 09:36 AM, NickCheng wrote:
> From: Nick Cheng <nick.cheng@areca.com.tw>
>
> Support hibernation for whole series of RAID controllers
> Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
> ---

Hi Nick,
this patch (2/5) already uses msi-x in the PM part, while the "Support MSI and MSI-X"
is added in the patch 3/5. You should switch the order - the support for msi-x should precede
the use of it in "Support Hibernation".
Tomas


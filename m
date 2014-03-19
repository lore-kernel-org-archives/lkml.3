Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaCSU4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:56:13 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58801 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaCSU4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:56:11 -0400
Message-ID: <532A1275.2020208@cogentembedded.com>
Date: Thu, 20 Mar 2014 00:56:05 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, haiyangz@microsoft.com
CC: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v3] hyperv: Add support for virtual Receive Side
 Scaling (vRSS)
References: <1395180922-2776-1-git-send-email-haiyangz@microsoft.com> <20140319.164005.1815461875771862691.davem@davemloft.net>
In-Reply-To: <20140319.164005.1815461875771862691.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/19/2014 11:40 PM, David Miller wrote:

>> +extern u8 netvsc_hash_key[];

> We no longer use extern in header file function declarations.

    Wait, this is a variable declaration. :-)

WBR, Sergei


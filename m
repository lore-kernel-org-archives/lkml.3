Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3BTXu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:50:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:54444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3BTXuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:50:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,705,1355126400"; 
   d="scan'208";a="204664758"
Message-ID: <51256157.6020205@linux.intel.com>
Date: Wed, 20 Feb 2013 15:50:47 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86, efi: Make "noefi" really disable EFI runtime serivces
References: <1361392572-25657-1-git-send-email-matt@console-pimps.org> <51256042.5030704@jp.fujitsu.com>
In-Reply-To: <51256042.5030704@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 03:46 PM, Satoru Takeuchi wrote:
> 
> Sorry, my patch was imperfect. This patch looks good to me.
> 

Perfection is something very rarely achieved.  That's why we work with
gradual improvements.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaHUKEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:04:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:23744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbaHUKEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:04:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="375203443"
Message-ID: <53F5C40C.8040100@linux.intel.com>
Date: Thu, 21 Aug 2014 13:03:56 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Alexander Duyck <alexander.duyck@intel.com>,
        Hyong-Youb Kim <hykim@myri.com>, Amir Vadai <amirv@mellanox.com>,
        Dmitry Kravkov <dmitry@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH 3.12 078/104] ixgbe: fix qv_lock_napi call in ixgbe_napi_disable_all
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz> <0977e9849d561464d21afb92b9f3746588a19c4f.1408535000.git.jslaby@suse.cz>
In-Reply-To: <0977e9849d561464d21afb92b9f3746588a19c4f.1408535000.git.jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/2014 14:43, Jiri Slaby wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> 3.12-stable review patch.  If anyone has any objections, please let me know.

No objection, I am however unable to test this myself at the moment.

I would suggest that someone takes a look at other drivers that support
busypoll, to make sure that they don't have a similar issue.

-Eliezer

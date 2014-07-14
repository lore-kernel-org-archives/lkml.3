Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaGNNOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:14:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:24743 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbaGNNOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,658,1400050800"; 
   d="scan'208";a="569505382"
Message-ID: <53C3D79D.1090101@linux.intel.com>
Date: Mon, 14 Jul 2014 06:14:05 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ionut Alexa <ionut.m.alexa@gmail.com>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel:async :changed printk to pr_debug to respect coding
 style.
References: <1405331138-26253-1-git-send-email-ionut.m.alexa@gmail.com>
In-Reply-To: <1405331138-26253-1-git-send-email-ionut.m.alexa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2014 2:45 AM, Ionut Alexa wrote:
> Fixed coding style issues by replacing printk with pr_debug.

these actual user prints are used by certain tools, like scripts/bootgraph.pl

you forgot to adapt these tools to the printk format change that you are doing....


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaF3M2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:28:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22232 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaF3M2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:28:50 -0400
Message-ID: <53B157F5.60501@oracle.com>
Date: Mon, 30 Jun 2014 08:28:37 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@joshtriplett.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu: NULL ptr deref on boot
References: <53ADA04B.3010707@oracle.com> <20140627171359.GG4603@linux.vnet.ibm.com>
In-Reply-To: <20140627171359.GG4603@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 01:13 PM, Paul E. McKenney wrote:
> Yikes!  tick_nohz_full_mask is allocated not in one place, but two!
> 
> Does the following patch help?

Yup, thanks Paul!


Thanks,
Sasha

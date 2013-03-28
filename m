Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3C1XZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 19:25:33 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:59292 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3C1XZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 19:25:32 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 19:25:31 EDT
Date: Fri, 29 Mar 2013 00:19:55 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bowgotsai@google.com,
        "'Ryankao'" <ryankao@realtek.com>
Subject: Re: r8169 auto speed down issue
Message-ID: <20130328231955.GA26182@electric-eye.fr.zoreil.com>
References: <4EECA12DD88643FD9006350514D96C8E@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EECA12DD88643FD9006350514D96C8E@realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
[...]
> Do you have any suggestion about this?

Your description suggests that testing against the link partner ability
to work at 10M instead of testing for tp->link_ok could be good enough.

Does it make sense ?

-- 
Ueimor

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3KNDDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 22:03:15 -0500
Received: from intranet.asianux.com ([58.214.24.6]:30155 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3KNDDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 22:03:03 -0500
X-Spam-Score: -100.8
Message-ID: <52843DE7.8020705@asianux.com>
Date: Thu, 14 Nov 2013 11:05:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "dhowells@redhat.com" <dhowells@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, mcree@orcon.net.nz,
        Dave Jones <davej@redhat.com>, sandeen@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, ak@linux.intel.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        alpha <linux-alpha@vger.kernel.org>
Subject: Re: [PATCH] arch: alpha: uapi: be sure of "_UAPI" prefix for all
 guard macros
References: <527B111C.7030303@asianux.com>
In-Reply-To: <527B111C.7030303@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 12:03 PM, Chen Gang wrote:
> For all uapi headers, need use "_UAPI" prefix for its guard macro
> (which will be stripped by "scripts/headers_installler.sh").
> 
> Also delete the redundant files (ipcbuf.h, kvm_para.h, and poll.h)
> which are already in Kbuild.
> 

Oh, sorry, need use 'generic-y' instead of 'header-y' in Kbuild, I will
send patch v2 for it.

Thanks.
-- 
Chen Gang

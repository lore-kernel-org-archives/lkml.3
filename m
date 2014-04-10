Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbaDJDOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:14:54 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51082 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbaDJDOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:14:52 -0400
Message-ID: <1397099672.25199.43.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index
 reflect the start/end section number
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Date: Thu, 10 Apr 2014 11:14:32 +0800
In-Reply-To: <53456C12.7000905@intel.com>
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
	 <533E0B0E.9020909@jp.fujitsu.com>
	 <1396945659.3162.6.camel@ThinkPad-T5421.cn.ibm.com>
	 <53442021.2060608@intel.com> <53443E8C.4070906@linux.vnet.ibm.com>
	 <53456C12.7000905@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041003-6102-0000-0000-0000054E7D67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 08:49 -0700, Dave Hansen wrote:
> On 04/09/2014 02:20 AM, Li Zhong wrote:
> > Or do you mean we don't need to expose any information related to
> > SECTION to userspace? 
> 
> Right, we don't need to expose sections themselves to userspace.  Do we?
> 
OK, I agree with that. 

Yanfei, I recall you once expressed your preference for section
numbers? 

Thanks, Zhong



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaFJIA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:00:29 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:53505 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFJIA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:00:28 -0400
Date: Tue, 10 Jun 2014 16:00:19 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, grant.likely@linaro.org,
        xiaoguangrong@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivercore: refine commit 58b116b "drivercore: deferral
 race condition fix"
Message-ID: <20140610080019.GA7200@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1399612799-12251-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20140521032143.GA8157@richard>
 <20140528205245.GC10468@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528205245.GC10468@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061008-6102-0000-0000-000005BE4783
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 01:52:45PM -0700, Greg KH wrote:
>On Wed, May 21, 2014 at 11:21:43AM +0800, Wei Yang wrote:
>> Hi~
>> 
>> Is this fix reasonable?
>
>I'll leave this up to Grant...

Grant, 

Do you have some comment?

-- 
Richard Yang
Help you, Help me


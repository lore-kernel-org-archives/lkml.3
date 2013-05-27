Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3E0HAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 03:00:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39382 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab3E0HAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 03:00:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,749,1363104000"; 
   d="scan'208";a="7377082"
Message-ID: <51A3027B.9090708@cn.fujitsu.com>
Date: Mon, 27 May 2013 14:51:39 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: Who uses kexec preserve context logic
References: <20121022185514.GF3401@redhat.com>
In-Reply-To: <20121022185514.GF3401@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/27 14:52:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/27 14:53:29,
	Serialize complete at 2013/05/27 14:53:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 02:55 AM, Vivek Goyal wrote:
> Hi,
> 
> I am just curious to know if somebody uses kexec preserve context path. I 
> have never used it personally and I don't know anybody who makes use of it.
> 
> Is it an unused code and should it be ripped out?
> 

Hi Vivek,

Related commit is:

3ab83521378268044a448113c6aa9a9e245f4d2f kexec jump

>From the commit, we can see its purpose is:

"The features of this patch can be used as a general method to call program in
physical mode (paging turning off).  This can be used to call BIOS code under
Linux."

Maybe someone from Intel still uses this...

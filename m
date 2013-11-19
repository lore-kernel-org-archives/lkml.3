Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3KSBeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:34:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36793 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab3KSBeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:34:03 -0500
X-IronPort-AV: E=Sophos;i="4.93,727,1378828800"; 
   d="scan'208";a="9069068"
Message-ID: <528ABD6E.8020004@cn.fujitsu.com>
Date: Tue, 19 Nov 2013 09:22:54 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Cedric Le Goater <clg@fr.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] nsproxy: Check to make sure count is truly zero before
 freeing
References: <20131113160339.7e0726fb@gandalf.local.home>	<877gc5l3hq.fsf@xmission.com> <20131118190457.7ad4e0a0@gandalf.local.home>
In-Reply-To: <20131118190457.7ad4e0a0@gandalf.local.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 09:19:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 09:32:06,
	Serialize complete at 2013/11/19 09:32:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 08:04 AM, Steven Rostedt wrote:
> 
> I'll start out saying that this email was a complete oops. I only kept
> it around for reference, as this didn't fix the bug we were seeing, and
> I used this email to just document what I initially thought.
> 

Can you describe the panic situation and the way to reproduce?
it's useful for us to find out the real problem.

Thanks.

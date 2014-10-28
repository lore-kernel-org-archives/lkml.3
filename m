Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaJ1QTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:19:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58984 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaJ1QTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:19:13 -0400
Date: Tue, 28 Oct 2014 09:15:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kevin Fenzi <kevin@scrye.com>
Cc: Yanko Kaneti <yaneti@declera.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cong Wang <cwang@twopensource.com>, netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        mroos@linux.ee, tj@kernel.org
Subject: Re: localed stuck in recent 3.18 git in copy_net_ns?
Message-ID: <20141028161502.GS5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141025020324.GA28247@linux.vnet.ibm.com>
 <11813.1414211613@famine>
 <20141025051602.GB28247@linux.vnet.ibm.com>
 <15891.1414255096@famine>
 <20141025181827.GE28247@linux.vnet.ibm.com>
 <20141027174539.GC27568@linux.vnet.ibm.com>
 <20141028081243.GA32082@declera.com>
 <20141028125059.GO5718@linux.vnet.ibm.com>
 <20141028130002.GA1682@declera.com>
 <20141028095428.15cadd01@voldemort.scrye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028095428.15cadd01@voldemort.scrye.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102816-0033-0000-0000-000000E2150E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:54:28AM -0600, Kevin Fenzi wrote:
> Just FYI, this solves the orig issue for me as well. ;) 
> 
> Thanks for all the work in tracking it down... 
> 
> Tested-by: Kevin Fenzi <kevin@scrye.com>

And thank you for testing as well!

							Thanx, Paul


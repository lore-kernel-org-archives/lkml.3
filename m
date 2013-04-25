Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab3DYLHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:07:43 -0400
Received: from ozlabs.org ([203.10.76.45]:42828 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab3DYLHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:07:42 -0400
Date: Thu, 25 Apr 2013 16:25:39 +1000
From: Paul Mackerras <paulus@samba.org>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: Chen Gang <gang.chen@asianux.com>, Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
Message-ID: <20130425062539.GA421@iris.ozlabs.ibm.com>
References: <5177965D.9090406@linux.vnet.ibm.com>
 <20130424083142.GB26834@concordia>
 <51779941.8080403@linux.vnet.ibm.com>
 <30651.1366799858@ale.ozlabs.ibm.com>
 <1366807638.5911.2.camel@localhost>
 <5178816D.3000309@asianux.com>
 <5178ABA2.4030109@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5178ABA2.4030109@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 12:05:54PM +0800, Mike Qiu wrote:
> This has block my work now
> So I hope you can take a look ASAP
> Thanks
> :)
> 
> Mike

As a quick fix, turn on CONFIG_KVM_BOOK3S_64_HV.  That will eliminate
the immediate problem.

Paul.

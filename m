Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3CEHGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:06:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:57509 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3CEHGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:06:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,785,1355097600"; 
   d="scan'208";a="10585549"
Message-ID: <1362467031.8941.51.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH LINUX v5] xen: event channel arrays are xen_ulong_t and
 not unsigned long
From: Ian Campbell <ian.campbell@citrix.com>
To: Rob Herring <robherring2@gmail.com>
CC: Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Keir (Xen.org)" <keir@xen.org>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Date: Tue, 5 Mar 2013 07:03:51 +0000
In-Reply-To: <513596F2.1000701@gmail.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
	 <1361360886-2956-1-git-send-email-ian.campbell@citrix.com>
	 <51340ACD.70904@gmail.com>
	 <20130305030436.GA18040@mudshark.cambridge.arm.com>
	 <513596F2.1000701@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 06:55 +0000, Rob Herring wrote:
> Here's a config:

Was it truncated? oldconfig is asking a ton of questions, far more than
I would expect for something like variance between our HEADs etc.

If I just answer the default to all the questions then I get a .config
with Xen on etc, but I still don't see the issue.

Ian.


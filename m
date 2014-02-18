Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaBRJCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:02:08 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41664 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaBRJB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:01:59 -0500
Message-ID: <53032023.5000403@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 14:26:03 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paulus@samba.org,
        oleg@redhat.com, rusty@rustcorp.com.au, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 00/52] CPU hotplug: Fix issues with callback registration
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021809-5564-0000-0000-00000C1272B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter, Thomas,

The CPU hotplug core pieces in this patchset have been Acked by Oleg Nesterov
and Gautham Shenoy. A majority of the remaining patches that do the tree-wide
conversions have been Acked by the various subsystem maintainers. Since those
patches have a build dependency on the second patch, it would be easiest to
take all these patches through one single tree.

Would you please consider taking all the patches in this series through your
tree?

Thank you very much!

Regards,
Srivatsa S. Bhat


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaFWAKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:10:33 -0400
Received: from ozlabs.org ([103.22.144.67]:47861 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaFWAKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:10:32 -0400
Message-ID: <1403482229.25739.1.camel@concordia>
Subject: Re: [tip:perf/core] powerpc, perf:  Use common PMU interrupt
 disabled code
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, cody@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, tglx@linutronix.de,
        fengguang.wu@intel.com
Date: Mon, 23 Jun 2014 10:10:29 +1000
In-Reply-To: <alpine.DEB.2.10.1406191435440.27913@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1406150203210.16738@vincent-weaver-1.umelst.maine.edu>
	 <tip-703daddffe550121e607c8294176ad2b12661147@git.kernel.org>
	 <alpine.DEB.2.10.1406191435440.27913@vincent-weaver-1.umelst.maine.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 14:40 -0400, Vince Weaver wrote:
> Brown-paper bag time, the patch didn't compile due to missing parenthesis.
> I really need to get a new powerpc machine to test on, haven't had one 
> since both my g3 and g4 laptops died.

https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.8.0/

cheers



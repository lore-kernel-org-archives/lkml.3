Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaDPUoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:44:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35855 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaDPUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:44:37 -0400
Date: Wed, 16 Apr 2014 13:44:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/torture.c: unmark torture_init_*  as __inline
Message-ID: <20140416204433.GZ4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <534EDBF4.6030702@gatech.edu>
 <534EDCC7.1040701@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534EDCC7.1040701@gatech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041620-0928-0000-0000-00000135C26D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 03:40:55PM -0400, Pranith Kumar wrote:
> The subject should be: 
> 
> [PATCH 1/1] kernel/torture.c: unmark torture_init_begin/end as __init

Actually "torture: Remove __init from torture_init_begin/end".

Good catch, queued for 3.16!  I missed it because of my habit of building
the torture tests directly into the kernel rather than loading them
as modules.  So thank you both for the patch and for your testing efforts!

Just out of curiosity, what are you thinking of using this for?

							Thanx, Paul


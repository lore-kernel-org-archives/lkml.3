Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaF3RLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:11:20 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38244 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaF3RLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:11:15 -0400
Date: Mon, 30 Jun 2014 10:11:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: josh@joshtriplett.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu: NULL ptr deref on boot
Message-ID: <20140630171103.GW4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53ADA04B.3010707@oracle.com>
 <20140627171359.GG4603@linux.vnet.ibm.com>
 <53B157F5.60501@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B157F5.60501@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063017-6688-0000-0000-000002F35CDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 08:28:37AM -0400, Sasha Levin wrote:
> On 06/27/2014 01:13 PM, Paul E. McKenney wrote:
> > Yikes!  tick_nohz_full_mask is allocated not in one place, but two!
> > 
> > Does the following patch help?
> 
> Yup, thanks Paul!

Glad it helped!

							Thanx, Paul


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaEENp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:45:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbaEENp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:45:57 -0400
Date: Mon, 5 May 2014 15:45:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Did you still need asynchronous grace-period detection?
Message-ID: <20140505134554.GP26782@laptop.programming.kicks-ass.net>
References: <20140502235355.GA13710@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140502235355.GA13710@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 04:53:56PM -0700, Paul E. McKenney wrote:
> Hello, Peter,
> 
> The following commit seems to have been dropped on the floor.
> Given that you haven't complained, I feel the need to ask you
> if you still need it.  ;-)
> 
> If you do need it, I will push it into 3.16.
> 

Yes, I do.. thanks for reminding me, I'll need to go find the patch that
needs it :-)

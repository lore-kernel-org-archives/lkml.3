Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3D3WHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744Ab3D3WHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:07:04 -0400
Date: Tue, 30 Apr 2013 18:06:47 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        paul.mckenney@linaro.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: rcu: Provide compile-time control for no-CBs CPUs
Message-ID: <20130430220647.GA16524@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	paul.mckenney@linaro.org, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org
References: <20130430214826.GK3780@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430214826.GK3780@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:48:26PM -0700, Paul E. McKenney wrote:

 > <snip excellent explanation>
 >
 > Should I add this to the Kconfig help text?  My guess is "not all of it",
 > but figured I should ask.

The commit msg would have been a great place for much of it, especially
the part explaining your desire to have users kick the tires etc.

 >  See below for my current best guess.

Much better. Be sure to pass on the 'terrible kconfig' award to the
next lucky recipient when their time comes :)

	Dave


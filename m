Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab3GABxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:53:34 -0400
Received: from ozlabs.org ([203.10.76.45]:58644 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab3GABxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:53:33 -0400
Date: Mon, 1 Jul 2013 11:53:30 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, icycoder@gmail.com,
        runzhew@clemson.edu
Subject: Re: [PATCH v3 0/2] perf tools: Power7 events name available for perf
Message-ID: <20130701015329.GA22928@concordia>
References: <1372407297-6996-1-git-send-email-runzhen@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372407297-6996-1-git-send-email-runzhen@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 04:14:55PM +0800, Runzhen Wang wrote:
> Thank for Sukadev Bhattip and Xiao Guangrong's help.
> Thank for Michael Ellerman's review. 
> 
> ChangeLog: v2 -> v3:
> 
> 1. Adding a leading zero to all the events code in "power7-events-list.h" 
>    which don't have a PMC, so that they all line up vertically.

Hi Runzhen,

These look good to me. Thanks for reworking them.

They seem to be on top of Arnaldo's tree, so it's probably easiest if he
takes them.

You can have my:

Acked-by: Michael Ellerman <michael@ellerman.id.au>


Arnaldo if you also want Benh's ack let us know and I'll pester him.

cheers

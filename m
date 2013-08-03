Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3HCAZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:25:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56688 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752744Ab3HCAZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:25:42 -0400
Message-ID: <1375489541.2034.151.camel@joe-AO722>
Subject: Re: [RFC v01 1/3] PowerCap: Documentation
From: Joe Perches <joe@perches.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Fri, 02 Aug 2013 17:25:41 -0700
In-Reply-To: <51FC4D9F.1070302@linux.intel.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <1375466932-11842-2-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <1375488644.2034.150.camel@joe-AO722> <51FC4D9F.1070302@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 17:23 -0700, Srinivas Pandruvada wrote:
> On 08/02/2013 05:10 PM, Joe Perches wrote:
> > On Fri, 2013-08-02 at 11:08 -0700, Srinivas Pandruvada wrote:
> >> Added power cap framework documentation. This explains the use of power capping framework,
> >> sys-fs and programming interface.
> > []
> Didn't understand this comment.

Not a comment, just notation showing skipping a bunch
context.

> > Given that the ranges seem to be u64s, perhaps the
> > lower bounds are too high.  Why not nano/pico/fempto
> > watts/joules/seconds?
> I think they are too small to realistically set a limits on power or 
> measure. Let's see what others think.

No rush.


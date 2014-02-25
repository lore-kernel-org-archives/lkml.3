Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaBYDdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:33:32 -0500
Received: from ozlabs.org ([203.10.76.45]:52051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaBYDd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:33:28 -0500
In-Reply-To: <1392415338-16288-4-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 03/11] sysfs: create bin_attributes under the requested group
Message-Id: <20140225033327.214B82C022C@ozlabs.org>
Date: Tue, 25 Feb 2014 14:33:27 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-14-02 at 22:02:07 UTC, Cody P Schafer wrote:
> bin_attributes created/updated in create_files() (such as those listed
> via (struct device).attribute_groups) were not placed under the
> specified group, and instead appeared in the base kobj directory.
> 
> Fix this by making bin_attributes use creating code similar to normal
> attributes.
> 
> A quick grep shows that no one is using bin_attrs in a named attribute
> group yet, so we can do this without breaking anything in usespace.
> 
> Note that I do not add is_visible() support to
> bin_attributes, though that could be done as well.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>

Greg has already taken this, so we'll consider that as good as an ack from him,
unless he wants to give us one.

cheers

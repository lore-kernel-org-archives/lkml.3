Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3JCECb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:02:31 -0400
Received: from ozlabs.org ([203.10.76.45]:52269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab3JCECa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:02:30 -0400
Date: Thu, 3 Oct 2013 14:02:20 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/9][v5] powerpc/perf: Rename Power8 macros to start with
 PME
Message-ID: <20131003040219.GA17237@concordia>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1380672911-12812-2-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380672911-12812-2-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 05:15:02PM -0700, Sukadev Bhattiprolu wrote:
> We use helpers like GENERIC_EVENT_ATTR() to list the generic events in
> sysfs. To avoid name collisions, GENERIC_EVENT_ATTR() requires the perf
> event macros to start with PME.

It's a bit unfortunate, because they no longer match the documentation,
or any of the comments. Are we seeing actual name collisions with PM_,
or is it just a theoretical worry?

cheers

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab3LTRDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:03:50 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50279 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3LTRDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:03:49 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 20 Dec 2013 09:03:09 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Ravi Patel <rapatel@apm.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Whitcroft <apw@canonical.com>, Kumar Sankaran <ksankaran@apm.com>,
        Loc Ho <lho@apm.com>, Keyur Chudgar <kchudgar@apm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch.pl error might be false positive
Message-ID: <20131220170308.GA26163@leaf>
References: <CAN1v_PvS3dH6HVQ90d=3cfsSdMgieyoDNp3VN-vrHv-aqSFEAw@mail.gmail.com>
 <1387491348.2353.20.camel@joe-AO722>
 <20131220075634.GA21784@leaf>
 <1387528630.2353.39.camel@joe-AO722>
 <20131220091621.GC21784@leaf>
 <1387531432.2353.44.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387531432.2353.44.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 01:23:52AM -0800, Joe Perches wrote:
> On Fri, 2013-12-20 at 01:16 -0800, Josh Triplett wrote:
> > Duplicating the regex seems awful.  Could you put it in a variable?
> 
> awful is a strong word and I don't have any
> issue with the duplication.  Using a variable
> is just as confusing as any duplication.

Fair enough; I don't care that much.  For your patch:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

- Josh Triplett

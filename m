Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaDDOpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:45:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35974 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaDDOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:45:17 -0400
Date: Fri, 4 Apr 2014 15:45:12 +0100
From: =?iso-8859-1?Q?Lu=EDs?= Henriques <luis.henriques@canonical.com>
To: David Miller <davem@davemloft.net>
Cc: sasha.levin@oracle.com, chien.yen@oracle.com, rds-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rds: prevent dereference of a NULL device in
 rds_iw_laddr_check
Message-ID: <20140404144512.GB2593@hercules>
References: <1396139975-5314-1-git-send-email-sasha.levin@oracle.com>
 <20140331.162607.153228065356865845.davem@davemloft.net>
 <20140404143136.GA2593@hercules>
 <20140404.104426.2226769084775433079.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140404.104426.2226769084775433079.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 10:44:26AM -0400, David Miller wrote:
> From: Luís Henriques <luis.henriques@canonical.com>
> Date: Fri, 4 Apr 2014 15:31:36 +0100
> 
> > Could you please queue this one for stable as well?  (Looks like it even
> > has CVE-2014-2678 assigned to it.)
> 
> Done.

That was fast!  Thanks :)

Cheers,
--
Luís

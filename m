Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaDDObm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:31:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaDDObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:31:41 -0400
Date: Fri, 4 Apr 2014 15:31:36 +0100
From: =?iso-8859-1?Q?Lu=EDs?= Henriques <luis.henriques@canonical.com>
To: David Miller <davem@davemloft.net>
Cc: sasha.levin@oracle.com, chien.yen@oracle.com, rds-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rds: prevent dereference of a NULL device in
 rds_iw_laddr_check
Message-ID: <20140404143136.GA2593@hercules>
References: <1396139975-5314-1-git-send-email-sasha.levin@oracle.com>
 <20140331.162607.153228065356865845.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140331.162607.153228065356865845.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Mar 31, 2014 at 04:26:07PM -0400, David Miller wrote:
> From: Sasha Levin <sasha.levin@oracle.com>
> Date: Sat, 29 Mar 2014 20:39:35 -0400
> 
> > Binding might result in a NULL device which is later dereferenced
> > without checking.
> > 
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> 
> Applied, thanks Sasha.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This is very similar to c2349758acf1874e4c2b93fe41d072336f1a31d0 ("rds:
prevent dereference of a NULL device"), which you've queued for stable.

Could you please queue this one for stable as well?  (Looks like it even
has CVE-2014-2678 assigned to it.)

Cheers,
--
Luís

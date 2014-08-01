Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaHAN6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:58:12 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:40099 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:58:08 -0400
Date: Fri, 1 Aug 2014 09:58:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] resource: Add device-managed
 request/release_resource()
Message-ID: <20140801135803.GD21624@htj.dyndns.org>
References: <1406895311-18869-1-git-send-email-thierry.reding@gmail.com>
 <20140801125522.GC21624@htj.dyndns.org>
 <20140801135540.GA373@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801135540.GA373@ulmo.nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 03:55:42PM +0200, Thierry Reding wrote:
> On Fri, Aug 01, 2014 at 08:55:22AM -0400, Tejun Heo wrote:
> > On Fri, Aug 01, 2014 at 02:15:10PM +0200, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > Provide device-managed implementations of the request_resource() and
> > > release_resource() functions. Upon failure to request a resource, the
> > > new devm_request_resource() function will output an error message for
> > > consistent error reporting.
> > > 
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > 
> > Acked-by: Tejun Heo <tj@kernel.org>
> > 
> > But please also update Documentation/driver-model/devres.txt.
> 
> The patch already contains the below hunk. Do you expect anything more
> to be added to that file?

Oops, I missed that.  All look fine to me.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaHAMz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:55:28 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:60263 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbaHAMz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:55:26 -0400
Date: Fri, 1 Aug 2014 08:55:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] resource: Add device-managed
 request/release_resource()
Message-ID: <20140801125522.GC21624@htj.dyndns.org>
References: <1406895311-18869-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406895311-18869-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 02:15:10PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Provide device-managed implementations of the request_resource() and
> release_resource() functions. Upon failure to request a resource, the
> new devm_request_resource() function will output an error message for
> consistent error reporting.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Tejun Heo <tj@kernel.org>

But please also update Documentation/driver-model/devres.txt.

Thanks.

-- 
tejun

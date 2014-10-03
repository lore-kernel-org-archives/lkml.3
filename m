Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaJCPsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:48:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaJCPsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:48:14 -0400
Date: Fri, 3 Oct 2014 08:48:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] dynamic_debug: change __dynamic_<foo>_dbg return types
 to void
Message-ID: <20141003154813.GA10004@kroah.com>
References: <1411582676.3594.12.camel@joe-AO725>
 <542EBD99.2030607@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542EBD99.2030607@akamai.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:15:37AM -0400, Jason Baron wrote:
> On 09/24/2014 02:17 PM, Joe Perches wrote:
> > The return value is not used by callers of these functions
> > so change the functions to return void.
> > 
> 
> Acked-by: Jason Baron <jbaron@akamai.com>
> 
> Greg - can you pick this up?

Yes, will do.

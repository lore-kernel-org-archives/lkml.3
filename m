Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3HBWd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:33:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56359 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670Ab3HBWd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:33:27 -0400
Message-ID: <1375482806.2034.140.camel@joe-AO722>
Subject: Re: [RFC v01 0/3] Power Capping Framework
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 15:33:26 -0700
In-Reply-To: <20130802223020.GB28831@kroah.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <20130802223020.GB28831@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-03 at 06:30 +0800, Greg KH wrote:
> On Fri, Aug 02, 2013 at 11:08:49AM -0700, Srinivas Pandruvada wrote:
> > Once this framework is approved, we will submit a RAPL client driver using this
> > framework.
> 
> Also, given that you work with a lot of kernel developers, I would like
> to see their review and signed-off-by: on these patches before you
> resend them, please.  That way I know that they agree with this
> framework as a way for their future changes in this area.

Before is a bit hard on public mailing lists isn't it?

Shouldn't the reviewed-by/acked-by/signed-off-by's be
done after a real patch is submitted?

This is just an RFC patchset.



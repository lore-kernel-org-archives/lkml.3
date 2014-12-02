Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaLBFgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:36:46 -0500
Received: from ozlabs.org ([103.22.144.67]:58880 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbaLBFgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:36:44 -0500
Message-ID: <1417498602.31336.7.camel@concordia>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Andrew Morton <akpm@osdl.org>, gorcunov@openvz.org
Date: Tue, 02 Dec 2014 16:36:42 +1100
In-Reply-To: <547C9E92.8010606@osg.samsung.com>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
	 <1417141122.6694.5.camel@concordia> <547C9E92.8010606@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 10:00 -0700, Shuah Khan wrote:
> On 11/27/2014 07:18 PM, Michael Ellerman wrote:
> > On Thu, 2014-10-23 at 16:07 +1100, Michael Ellerman wrote:
> >> kcmp.h appears to be part of the API, it's documented in kcmp(2), and
> >> the selftests/kcmp code uses it. So move it to uapi so it's actually
> >> exported.
> > 
> > Looks like this series fell through the cracks?
> > 
> > It still applies on rc6. Should I resend?
> > 
> > cheers
> > 
> >> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> 
> I am expecting a patch v2 for the series based on the comments
> on the series. Please see my responses to the individual patch
> threads.

Sure, will repost.

cheers



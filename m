Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3FLRjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:39:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab3FLRjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:39:04 -0400
Date: Wed, 12 Jun 2013 10:39:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        thierry.reding@gmail.com, patches@linaro.org,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH 15/15] lib: devres: Remove deprecated
 devm_request_and_ioremap
Message-ID: <20130612173940.GB20850@kroah.com>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
 <1370864113-17895-16-git-send-email-tushar.behera@linaro.org>
 <CAHp75Ve31DA5WVWH7Ha0s+Voe8v77Q_8nOXhg1fKODb0zJxg5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Ve31DA5WVWH7Ha0s+Voe8v77Q_8nOXhg1fKODb0zJxg5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 03:43:59PM +0300, Andy Shevchenko wrote:
> On Mon, Jun 10, 2013 at 2:35 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
> > Now that all the users of devm_request_and_ioremap have been converted
> > to use devm_ioremap_resource, remove the definition.
> 
> This is a function which was exported to the drivers including
> third-party drivers.

That doesn't matter, we've cleaned up all in-kernel users of it, so we
can safely delete it.

> I suggest to mark it as __deprecated and wait couple of release cycles.

No, that's not going to help anyone, just delete it and move on.

thanks,

greg k-h

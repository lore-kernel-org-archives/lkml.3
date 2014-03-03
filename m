Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaCCWvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:51:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbaCCWve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:51:34 -0500
Date: Mon, 3 Mar 2014 17:51:26 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, Gao feng <gaofeng@cn.fujitsu.com>,
        eparis@redhat.com, sgrubb@redhat.com
Subject: Re: [PATCH] audit: don't generate loginuid log when audit disabled
Message-ID: <20140303225126.GL16640@madcap2.tricolour.ca>
References: <4c215d4514933983db3f162c0f6bf6a2a25221e7.1393353030.git.rgb@redhat.com>
 <20140303224904.GA26305@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303224904.GA26305@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/03, Greg KH wrote:
> On Mon, Mar 03, 2014 at 05:30:50PM -0500, Richard Guy Briggs wrote:
> > From: Gao feng <gaofeng@cn.fujitsu.com>
> > 
> > If audit is disabled, we shouldn't generate loginuid audit
> > log.
> > 
> > Cc: stable@vger.kernel.org # v3.13-rc1
> > Acked-by: Eric Paris <eparis@redhat.com>
> > Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> > Already upstream in 3.14-rc1.  This fixes a bug introduced by:
> > 	da0a6104 audit: loginuid functions coding style
> 
> What is the git id of the patch in Linus's tree?

Sorry, here you go: c2412d9

> greg k-h

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

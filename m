Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab3GOPBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:01:46 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:37339 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3GOPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:01:44 -0400
Date: Mon, 15 Jul 2013 17:01:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
Subject: Re: 3.10.0: Full dynticks = high load
Message-ID: <20130715150134.GB6442@somewhere>
References: <krlv29$jbp$1@ger.gmane.org>
 <20130712065227.GC1985@fancy-poultry.org>
 <ks0s36$ntc$1@ger.gmane.org>
 <1373895406.7353.99.camel@marge.simpson.net>
 <20130715142556.GA6442@somewhere>
 <51e40c69.e8c6ec0a.14aa.fffff47c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51e40c69.e8c6ec0a.14aa.fffff47c@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:51:18AM -0300, Dâniel Fraga wrote:
> On Mon, 15 Jul 2013 16:25:59 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > Sorry I'm missing the description of the issue. Could you please
> > repaste it?
> > 
> > Thanks!
> 
> 	The problem is that when we use the new Full dynticks option
> form kernel 3.10.0, the load will go high, always above 1. Bug?

You mean this is the result that the "uptime" command gives you? And
your system is doing something? Or is it mostly idle?

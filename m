Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3CAXvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 18:51:52 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:40613 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3CAXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 18:51:50 -0500
Date: Sat, 2 Mar 2013 01:51:39 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, pali.rohar@gmail.com,
        tony@atomide.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Message-ID: <20130301235138.GD22941@blackmetal.musicnaut.iki.fi>
References: <604513288.26328.1362132552062.JavaMail.apache@mail83.abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <604513288.26328.1362132552062.JavaMail.apache@mail83.abv.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 12:09:12PM +0200, Ивайло Димитров wrote:
> Unfortunately it is necessary, on RX-51 PPA/NOLO leaves IBE bit unset.

You sure? I think you need to explain this more - the commit message in
the original patch is empty/missing...

A.

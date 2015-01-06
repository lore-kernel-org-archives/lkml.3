Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbbAFGCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:02:38 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64272 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbAFGCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:02:37 -0500
Date: Tue, 6 Jan 2015 11:32:26 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Piotr Kubus <p.t.kubus@gmail.com>
Cc: Konrad Zapalowicz <bergo.torino@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: dmm32at: Fixed a code indent issue
Message-ID: <20150106060226.GA4285@sudip-PC>
References: <1420384955-27336-1-git-send-email-p.t.kubus@gmail.com>
 <20150104223129.GF25819@t400>
 <20150105192406.GA2686@PiotrekLap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105192406.GA2686@PiotrekLap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 08:24:06PM +0100, Piotr Kubus wrote:
> On Sun, Jan 04, 2015 at 11:31:29PM +0100, Konrad Zapalowicz wrote:
> > On 01/04, Piotr Kubus wrote:
> > > This is a patch to the dmm32at.c file that fixes up a code indent error found by the checkpatch.pl tool.
> > 
> > Nice however improve your commit message. The rule is that the lines
> > should wrap at 72nd column except for quoted material such as compiler
> > output, etc...
> > 
> > The 72-character columns are important for allowing quoting and they
> > play nicely with standard indentation from git log.
> 
> Hey,
> 
> I couldn't find that rule in Kernel documentation. Besides there were no
> complaints from checkpatch.pl tool.

Please check SubmittingPatches in Documentation. It says:
'the "summary" must be no more than 70-75 characters'


thanks
sudip

> Piotr
> 
> > 
> > Thanks,
> > Konrad
> > 
<snip>
> Please read the FAQ at  http://www.tux.org/lkml/

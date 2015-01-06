Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbbAFK1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:27:44 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62976 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbAFK1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:27:41 -0500
Date: Tue, 6 Jan 2015 15:57:30 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Piotr Kubus <p.t.kubus@gmail.com>,
        Konrad Zapalowicz <bergo.torino@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] Staging: comedi: dmm32at: Fixed a code indent issue
Message-ID: <20150106102730.GA26052@sudip-PC>
References: <1420384955-27336-1-git-send-email-p.t.kubus@gmail.com>
 <20150104223129.GF25819@t400>
 <20150105192406.GA2686@PiotrekLap>
 <20150106060226.GA4285@sudip-PC>
 <54ABB425.1080207@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ABB425.1080207@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:08:37AM +0000, Ian Abbott wrote:
> On 06/01/15 06:02, Sudip Mukherjee wrote:
> >On Mon, Jan 05, 2015 at 08:24:06PM +0100, Piotr Kubus wrote:
> >>On Sun, Jan 04, 2015 at 11:31:29PM +0100, Konrad Zapalowicz wrote:
> >>>On 01/04, Piotr Kubus wrote:
> >>>>This is a patch to the dmm32at.c file that fixes up a code indent error found by the checkpatch.pl tool.
> >>>
> >>>Nice however improve your commit message. The rule is that the lines
> >>>should wrap at 72nd column except for quoted material such as compiler
> >>>output, etc...
> >>>
> >>>The 72-character columns are important for allowing quoting and they
> >>>play nicely with standard indentation from git log.
> >>
> >>Hey,
> >>
> >>I couldn't find that rule in Kernel documentation. Besides there were no
> >>complaints from checkpatch.pl tool.
> >
> >Please check SubmittingPatches in Documentation. It says:
> >'the "summary" must be no more than 70-75 characters'
> 
> In this case, it's not the "summary" that's at issue, it's the body
> of the commit message, as Konrad mentioned above.

yes, i read the SubmittingPatches again. summary is the subject line. But then as Piotr Kubus has written that he could not find this rule in the documentaion, I also tried to find that in SubmittingPatches file and also in the Posting file of the development-process folder, but could not find it. Is it mentioned in some other file we missed ?

sudip
> 
> -- 
> -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
> -=(                          Web: http://www.mev.co.uk/  )=-

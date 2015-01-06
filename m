Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbbAFNui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:50:38 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56417 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbbAFNug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:50:36 -0500
Date: Tue, 6 Jan 2015 19:20:25 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>, Piotr Kubus <p.t.kubus@gmail.com>,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH] Staging: comedi: dmm32at: Fixed a code indent issue
Message-ID: <20150106135025.GA17196@sudip-PC>
References: <1420384955-27336-1-git-send-email-p.t.kubus@gmail.com>
 <20150104223129.GF25819@t400>
 <20150105192406.GA2686@PiotrekLap>
 <20150106060226.GA4285@sudip-PC>
 <54ABB425.1080207@mev.co.uk>
 <20150106102730.GA26052@sudip-PC>
 <20150106133327.GG25819@t400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106133327.GG25819@t400>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 02:33:27PM +0100, Konrad Zapalowicz wrote:
> On 01/06, Sudip Mukherjee wrote:
> > yes, i read the SubmittingPatches again. summary is the subject line. But then as Piotr Kubus has written that he could not find this rule in the documentaion, I also tried to find that in SubmittingPatches file and also in the Posting file of the development-process folder, but could not find it. Is it mentioned in some other file we missed ?
> 
> Then it is an 'unwritten rule' :) You can observe it just be browsing
> the git log commit messages - pick a few random and you will see.
i don't need to veify it, I don't doubt the rule. if you see all the patches i have sent, i have always maintained a rule of 70.
just curious why this 72 ..
this one gives a reason why -

http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html 

sudip

> 
> Moreover in the http://git-scm.com/book/ch5-2.html the 72-character
> columns are the example of the good commit message plus Linus says so:
> 
> 	"we use 72-character columns for word-wrapping, except for quoted
> 	material that has a specific line format."
> 
> in one of his comments
> https://github.com/torvalds/linux/pull/17#issuecomment-5661185
> 
> cheers,
> konrad
> 
> > sudip
> > > 
> > > -- 
> > > -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
> > > -=(                          Web: http://www.mev.co.uk/  )=-

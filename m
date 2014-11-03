Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaKCRpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:45:54 -0500
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:53762 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752324AbaKCRpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:45:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:6261:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13095:13181:13200:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crack68_6d1ae86752f4c
X-Filterd-Recvd-Size: 1824
Message-ID: <1415036747.17743.24.camel@perches.com>
Subject: Re: [PATCH v2 1/2] ALSA: echoaudio: add reference of struct
 echoaudio
From: Joe Perches <joe@perches.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Nov 2014 09:45:47 -0800
In-Reply-To: <20141103165243.GA7562@sudip-PC>
References: <1415010853-4334-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <s5hwq7c1i7k.wl-tiwai@suse.de> <1415027288.17743.16.camel@perches.com>
	 <20141103165243.GA7562@sudip-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 22:22 +0530, Sudip Mukherjee wrote:
> On Mon, Nov 03, 2014 at 07:08:08AM -0800, Joe Perches wrote:
[]
> > ftrace exists and is generic.
> > 
> > Several of these seem to be function tracing
> > style uses and should just be deleted instead.
> 
> function tracing style uses means?

ftrace

see:

Documentation/trace/ftrace.txt
Documentation/trace/ftrace-design.txt

> there are some prints which are printing the function name while printing the debug message.
> are those function tracing style uses??

A debug message should generally not be emitting a
message just for the sake of documenting when a
function is entered/left.

Sometimes that is useful for initial debugging, but
almost always those debugging printks should not be
left in the code that is pushed to kernel.org.



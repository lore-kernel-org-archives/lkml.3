Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaLFCyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:54:05 -0500
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:33329 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751792AbaLFCyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:54:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3657:3770:3865:3866:3867:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6261:8603:8985:9025:9388:10004:10400:10848:11026:11232:11658:11914:12043:12114:12517:12519:12555:12740:13069:13255:13311:13357:13437:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nut01_4031db22d8d1b
X-Filterd-Recvd-Size: 1390
Message-ID: <1417834439.31745.7.camel@perches.com>
Subject: Re: [PATCH] [PATCH] VERIFY_OCTAL_PERMISSIONS: Move to
 <linux/sysfs.h> where it belongs
From: Joe Perches <joe@perches.com>
To: George Spelvin <linux@horizon.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, rusty@rustcorp.com.au,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 05 Dec 2014 18:53:59 -0800
In-Reply-To: <20141206024952.24901.qmail@ns.horizon.com>
References: <20141206024952.24901.qmail@ns.horizon.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 21:49 -0500, George Spelvin wrote:
> I found some other alarming things, but nothing related to this.
> 
> E.g.
> drivers/net/ethernet/intel/i40e/i40e_debugfs.c: In function 'i40e_dbg_dump_desc':
> drivers/net/ethernet/intel/i40e/i40e_debugfs.c:855:1: warning: the frame size of 8192 bytes is larger than 2048 bytes [-Wframe-larger-than=]

Patched.
Waiting for Jeff Kirsher to get 'round to applying it.

http://patchwork.ozlabs.org/patch/411356/



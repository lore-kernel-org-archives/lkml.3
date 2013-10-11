Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab3JKHAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:00:44 -0400
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:47815 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752326Ab3JKHAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:00:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 20,1.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2317:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3871:4250:4321:5007:7652:7903:9165:10004:10400:10429:10430:10431:10848:11232:11658:11914:12296:12517:12519:12555:12740:13069:13311:13357:19903:19997,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cause86_7a6ad3c3ab01d
X-Filterd-Recvd-Size: 1728
Message-ID: <1381474839.27498.11.camel@joe-AO722>
Subject: Re: Extended H/W error log driver
From: Joe Perches <joe@perches.com>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Date: Fri, 11 Oct 2013 00:00:39 -0700
In-Reply-To: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 02:32 -0400, Chen, Gong wrote:
> This patch series adds an enhanced MCA event logging driver provided by Intel.
[]
> dmesg output:
> 
> [56005.785917] {3}Hardware error detected on CPU0
> [56005.785959] {3}event severity: corrected
> [56005.785975] {3}sub_event[0], severity: corrected
> [56005.785977] {3}section_type: memory error
> [56005.785981] {3}physical_address: 0x0000000851fe0000
> [56005.786027] {3}DIMM location: Memriser1 CHANNEL A DIMM 0
> [56005.786154] {4}Hardware error detected on CPU0
> [56005.786159] {4}event severity: corrected
> [56005.786162] {4}sub_event[0], severity: corrected
> [56005.786166] {4}section_type: memory error
[]
> So welcome to add comments for what is needed or not.

Perhaps there can be a better standardized prefix other than {seq}
like KBUILD_MODNAME or some other useful identifier like subsystem
name.



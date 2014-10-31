Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895AbaJaWMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:12:39 -0400
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:40254 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751541AbaJaWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:12:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3350:3622:3867:3870:4321:5007:6261:10004:10400:10848:11026:11658:11914:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: river70_50f5c246fe60c
X-Filterd-Recvd-Size: 1487
Message-ID: <1414793554.13647.5.camel@perches.com>
Subject: Re: [PATCH 7/8] cdrom: cdrom: export sysctl code
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Fri, 31 Oct 2014 15:12:34 -0700
In-Reply-To: <1414792084-7739-8-git-send-email-fabf@skynet.be>
References: <1414792084-7739-1-git-send-email-fabf@skynet.be>
	 <1414792084-7739-8-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 22:48 +0100, Fabian Frederick wrote:
> -Move all sysctl operations to cdrom_sysctl
> -Remove static/add extern in cdrom.h for some variables
> -Rename debug to cdrom_debug
> -Fix some checkpatch warnings
> -Update cdrom makefile accordingly.
[]
> diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
[]
> +extern bool cdrom_debug;
> +extern bool autoclose;
> +extern bool autoeject;
> +extern bool lockdoor;
> +extern bool check_media_type;
> +extern bool mrw_format_restart;
> +extern struct list_head cdrom_list;
> +extern struct mutex cdrom_mutex;

I think these should be prefixed with "cdrom_"



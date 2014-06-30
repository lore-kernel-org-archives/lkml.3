Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaF3KyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:54:22 -0400
Received: from smtprelay0119.b.hostedemail.com ([64.98.42.119]:36435 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755133AbaF3KyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:54:21 -0400
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2014 06:54:21 EDT
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Spam-Summary: 50,3,0,,d41d8cd98f00b204,t.artem@lycos.com,:,RULES_HIT:41:46:150:153:355:379:582:988:989:1152:1261:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3622:3690:3865:3867:3868:3874:5007:6261:7903:10004:10400:10450:10455:11658:11914:11984:12517:12519:13019:13069:13071:13255:13311:13357:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: star42_156ef1b9ca402
X-Filterd-Recvd-Size: 1180
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 30 Jun 2014 15:45:47 +0500
From: t.artem@lycos.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: BLKRASET =?UTF-8?Q?=28ra=5Fpages=29=20on=20a=20per=20partition=20?=
 =?UTF-8?Q?basis?=
Message-ID: <882e8e779e724990b242ecdab21c484d@lycos.com>
User-Agent: Roundcube Webmail/1.0.1
X-Originating-IP: [5.166.185.249]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wonder how difficult and feasible would be to implement per partition 
readahead settings.

Currently the Linux kernel sets readahead for the entire device, as 
opposed to individual partitions and that's absolutely inconvenient.

For instance, I don't want large readahead numbers for my / and /home 
partitions, however for my /mnt/media partition setting a high readahead 
value would be very beneficial.



Artem


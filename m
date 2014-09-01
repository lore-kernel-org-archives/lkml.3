Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaIAWR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:17:56 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:56122 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbaIAWRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:17:55 -0400
Message-ID: <1409609873.5546.13.camel@x220>
Subject: Re: [PATCH] Drivers:firewire: fix style errors in core-card.c This
 is a patch in the core-card.c file which fixes up 2 warnings found by the
 checkpatch.pl tool Signed-off-by: Sander Nemvalts <snemvalts@gmail.com>
From: Paul Bolle <pebolle@tiscali.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sander Nemvalts <snemvalts@gmail.com>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2014 00:17:53 +0200
In-Reply-To: <20140901235605.5466b6a6@kant>
References: <1409597306-22164-1-git-send-email-snemvalts@gmail.com>
	 <20140901235605.5466b6a6@kant>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2014 22:17:52.0882 (UTC) FILETIME=[92B1BD20:01CFC632]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a crowded subject line!

On Mon, 2014-09-01 at 23:56 +0200, Stefan Richter wrote:
> On Sep 01 Sander Nemvalts wrote:
> > @@ -132,7 +133,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
> >  	j = 7 + descriptor_count;
> >  
> >  	/* Generate root directory entries for descriptors. */
> > -	list_for_each_entry (desc, &descriptor_list, link) {
> > +	list_for_each_entry(desc, &descriptor_list, link) {
> >  		if (desc->immediate > 0)
> >  			config_rom[i++] = cpu_to_be32(desc->immediate);
> >  		config_rom[i] = cpu_to_be32(desc->key | (j - i));
> 
> We are writing
> 	for (a; b; c);
> not
> 	for(a; b; c);
> and thus a space after list_for_each and friends makes sense.

$ git grep "list_for_each_entry (" | wc -l
52
$ git grep "list_for_each_entry(" | wc -l
5991

So "list_for_each_entry(" (without space) seems to be the preferred
style.


Paul Bolle


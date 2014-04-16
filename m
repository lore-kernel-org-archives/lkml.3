Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161631AbaDPOj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:39:57 -0400
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:35401 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161426AbaDPOjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:39:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wax12_1c08f6837e844
X-Filterd-Recvd-Size: 1571
Message-ID: <1397659190.32088.4.camel@joe-AO722>
Subject: Re: [PATCH] staging : android : uapi : fix coding style
From: Joe Perches <joe@perches.com>
To: Seunghun Lee <waydi1@gmail.com>, John Stultz <john.stultz@linaro.org>
Cc: greg@kroah.com, swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Apr 2014 07:39:50 -0700
In-Reply-To: <1397658459-4357-1-git-send-email-waydi1@gmail.com>
References: <1397658459-4357-1-git-send-email-waydi1@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding John Stultz)

On Wed, 2014-04-16 at 23:27 +0900, Seunghun Lee wrote:
> This patch fix checkpatch.pl warnings and errors.
[]
> diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
[]
> @@ -169,7 +169,7 @@ struct binder_ptr_cookie {
>  struct binder_handle_cookie {
>  	__u32 handle;
>  	binder_uintptr_t cookie;
> -} __attribute__((packed));
> +} __packed;

If this .h file is meant to be a user-space #include,
then it should not use the kernel specific __packed
but keep the __attribute__((packed))

It does use __u32 though and that's generally
kernel specific.

John?  Does any of these binder uapi files need a
bit more sorting out?


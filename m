Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaK2Ryr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:54:47 -0500
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:50368 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751339AbaK2Ryp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:54:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:4321:5007:6261:7514:7904:10004:10400:10848:11026:11232:11658:11914:12114:12517:12519:12555:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: note17_63770eb33ed16
X-Filterd-Recvd-Size: 1754
Message-ID: <1417283681.818.1.camel@perches.com>
Subject: Re: [PATCH] Drivers:input:mousedev.c: Fixed trailing statement on
 the next line
From: Joe Perches <joe@perches.com>
To: Athira S <athirasnamby@gmail.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 29 Nov 2014 09:54:41 -0800
In-Reply-To: <1417278043-4870-1-git-send-email-athirasnamby@gmail.com>
References: <1417278043-4870-1-git-send-email-athirasnamby@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-29 at 21:50 +0530, Athira S wrote:
> Fixed checkpatch error:
> trailing statements should be on next line
> 
> signed-off-by: Athira S <athirasnamby@gmail.com>
> ---
>  drivers/input/mousedev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> index be2cc5c..28988f5 100644
> --- a/drivers/input/mousedev.c
> +++ b/drivers/input/mousedev.c
> @@ -248,8 +248,8 @@ static void mousedev_key_event(struct mousedev *mousedev,
>  	case BTN_4:
>  	case BTN_EXTRA:		index = 4; break;
>  
> -	default:
> -	return;
> +	default:	
> +				return;

Please run your suggested patches though
scripts/checkpatch.pl before sending them.

Don't send patches on top of your own
unapplied patches.  Use the original and
create a new patch.

Probably none of this needs to be changed.



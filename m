Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaHVQNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:13:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaHVQNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:13:02 -0400
Date: Fri, 22 Aug 2014 11:12:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/ipack/devices/ipoctal.h: Fix typo in include
 guard
Message-ID: <20140822161219.GA21154@kroah.com>
References: <1408709363-13361-1-git-send-email-linux@rasmusvillemoes.dk>
 <4b63988bb76babf9516c1dbcf38ce463@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b63988bb76babf9516c1dbcf38ce463@igalia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 02:36:44PM +0200, Samuel Iglesias Gonsálvez wrote:
> On 2014-08-22 14:09, Rasmus Villemoes wrote:
> >Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> >---
> > drivers/ipack/devices/ipoctal.h | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/ipack/devices/ipoctal.h
> >b/drivers/ipack/devices/ipoctal.h
> >index 28f1c42..7fede0e 100644
> >--- a/drivers/ipack/devices/ipoctal.h
> >+++ b/drivers/ipack/devices/ipoctal.h
> >@@ -12,7 +12,7 @@
> >  * Software Foundation; version 2 of the License.
> >  */
> >
> >-#ifndef _IPOCTAL_H
> >+#ifndef _IPOCTAL_H_
> > #define _IPOCTAL_H_
> >
> > #define NR_CHANNELS		8
> 
> Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> 
> Greg, Would you mind picking this patch through your char-misc tree?

Sure, will do.

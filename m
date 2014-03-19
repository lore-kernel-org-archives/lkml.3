Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaCSSDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:03:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35527 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaCSSD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:03:28 -0400
Date: Wed, 19 Mar 2014 19:03:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Teodora Baluta <teobaluta@gmail.com>
Cc: linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140319180323.GG14929@pd.tnic>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
> This feature encodes Oops messages into a QR barcode that is scannable by
> any device with a camera.
> 
> If the config option for this feature is enabled, then when an Oops is
> in progress, the printk() calls' strings are buffered. When the Oops
> finishes, the buffer is compressed, encoded into a QR and then displayed
> to frame buffer. The compression is done with zlib from lib/.
> 
> Current issues:
>  * the QR code is sometimes displayed on top of the console text,
>    sometimes under it, thus making it unscannable
>  * the compression rate could be better than what zlib offers
>  * not tested for Oops messages issued from several CPUs
> 
> As far as decoding is concerned, there are a lot of apps on mobile devices
> that decode QR codes (just text mostly). In order to make this work, an
> app which also decodes the QR code is needed. I will be working the next
> couple of weeks on an Android app which scans the Oops encoding QR and
> sends it to a server which keeps track of these Oopses that are sent to
> it making a sort of stream of the latest Oopses. Any thoughts on what the best
> workflow would be are more than welcomed.
> 
> Also, if there are any suggestions on how to solve some of the issues,
> they are more than welcomed.

Definitely a great idea. Which tree is the patch against?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

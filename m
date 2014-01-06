Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaAFIoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:44:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaAFIoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:44:01 -0500
Message-ID: <1388997831.8379.43.camel@marge.simpson.net>
Subject: Re: How does a newbie find work?
From: Mike Galbraith <bitbucket@online.de>
To: "Gideon D'souza" <gidisrael@gmail.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 06 Jan 2014 09:43:51 +0100
In-Reply-To: <CAPNrq4yJBEJo3yadttN2G_+-nmUPihvDCR8M6R7KGO3LO_kDMA@mail.gmail.com>
References: <CAPNrq4yXdbdfq4hrtZdZn_5UDPduGoTCNJb1-9u-Qf1nf2RgXQ@mail.gmail.com>
	 <20140105212951.4e13b083@alan.etchedpixels.co.uk>
	 <CAPNrq4yJBEJo3yadttN2G_+-nmUPihvDCR8M6R7KGO3LO_kDMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:k6eKMKZEXvPPlYVOAOsD7ucyH+cKYHYYUH5Ex5J66wq
 ivwYGziN2mDegWuJTRGsDEEFdPmw2a9TAW0cfgqTCbnNtquO+6
 Sp0+J+GFKV/e7L4t3Fvl7f9PDIqnIxtqCQQHY4HePAzFPornoF
 AT69bHVG30agsa/f2wnV5QIZtufaX3rsQLqctArB62DPNmhPyY
 gqPtKZZWf6vLCCi7NSmdBLFjUpj5MqygTCQ2GGUbn+nnQ1UqlQ
 mHNZDggQHeqCQXsdeFWK87V6KDo9wUfaHdApHlnJmAkYFj1F/N
 pcG+zjjCmL965BkFd6L9UtPfXtzrVLvV8eJiq4QPV0ISA2/rQq
 QQUPiyz+dToPWpQXCbwvIE8qCUaFwSnjUzIyG31uJ17yI1fOqJ
 U8PnU7Te3Bm7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 12:53 +0530, Gideon D'souza wrote: 
> So I was thinking of this hideous project (don't laugh!) at tearing
> out the CFS scheduler and then rewriting a very dumb scheduler in it's
> place. What do you guys think?  This is of course just to understand
> the scheduler better.
> 
> I just don't know how large or ridiculous this is though :)

Ripping CFS apart and putting it back together in better working order
is a better project.  Ripping things to bits is easy, it's the putting
things back together that can get down right interesting :)

-Mike


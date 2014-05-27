Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaE0G5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:57:15 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:33143 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaE0G5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:57:14 -0400
Message-ID: <1401173825.30496.13.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1] sound/aoa/codecs/onyx.c: use static const for texts
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 27 May 2014 08:57:05 +0200
In-Reply-To: <20140527085452.5fc3f193971c47e6bac295d8@skynet.be>
References: <20140527085452.5fc3f193971c47e6bac295d8@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 08:54 +0200, Fabian Frederick wrote:
> 'texts' is only used as source in strcpy

Looks fine to me, but you should probably send it to the alsa list and
the audio maintainer, not lkml and Andrew.

johannes


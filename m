Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaLMAGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 19:06:30 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaLMAG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 19:06:27 -0500
Date: Fri, 12 Dec 2014 16:05:21 -0800
From: Darren Hart <dvhart@infradead.org>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Takashi Iwai <tiwai@suse.de>, Dominique Leuenberger <dimstar@opensuse.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hp_accel: Add support for HP ZBook 15
Message-ID: <20141213000520.GA76819@vmdeb7>
References: <1415908657-26477-1-git-send-email-tiwai@suse.de>
 <5489713F.9050408@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5489713F.9050408@tremplin-utc.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:26:07AM +0100, Éric Piel wrote:
> On 13-11-14 20:57, Takashi Iwai wrote:
> >From: Dominique Leuenberger <dimstar@opensuse.org>
> >
> >HP ZBook 15 laptop needs a non-standard mapping (x_inverted).
> >
> >BugLink: http://bugzilla.opensuse.org/show_bug.cgi?id=905329
> >Signed-off-by: Dominique Leuenberger <dimstar@opensuse.org>
> >Cc: <stable@vger.kernel.org>
> >Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Sorry, it got a be delayed... but it looks completely fine :-)
> 
> Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
> 
> Darren, would you wind picking up this patch via your tree?

Yes, already in next.

Thanks :-)

-- 
Darren Hart
Intel Open Source Technology Center

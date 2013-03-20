Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab3CTPWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:22:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49851 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316Ab3CTPWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:22:17 -0400
Message-ID: <1363792936.16270.30.camel@joe-AO722>
Subject: Re: [PATCH] sound: max98090: Remove executable bit
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 08:22:16 -0700
In-Reply-To: <20130320095758.GD28775@opensource.wolfsonmicro.com>
References: <1363730323.16270.11.camel@joe-AO722>
	 <20130320095758.GD28775@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 10:57 +0100, Mark Brown wrote:
> On Tue, Mar 19, 2013 at 02:58:43PM -0700, Joe Perches wrote:
> > Source files shouldn't have the executable bit set.
> 
> I've applied this but I'm fed up to the back teeth of having to hand
> edit trivial patches from you because you ignore the subject line styles
> of subsystems and make up your own.

Your style rules just don't matter to me and
you can ignore the patches and fix it yourself.

Or better, create a tool for others to use that
follow your silly style rules.



